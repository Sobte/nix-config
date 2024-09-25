{
  pkgs,
  config,
  lib,
  namespace,
  host,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkOption types;
  inherit (lib.${namespace}) mkMappingOption;
  inherit (config.age) secrets;

  cfgParent = config.${namespace}.services.gitea;
  cfg = cfgParent.secrets;

  onlyOwner = {
    inherit (config.users.users.${cfg.owner}) uid;
    inherit (config.users.groups.${group}) gid;
    # Read-only
    mode = "0400";
  };
  group = "gitea";
in
{
  options.${namespace}.services.gitea.secrets = with types; {
    enable = lib.mkEnableOption "gitea" // {
      # If gitea is started, secrets are enabled by default
      default = cfgParent.enable && cfgParent.useWizard && config.${namespace}.shared.secrets.enable;
    };
    etc = {
      enable = lib.mkEnableOption "bind to etc" // {
        default = true;
      };
      useSymlink = lib.mkEnableOption "use symlink to etc" // {
        default = isDarwin || (onlyOwner.uid == null);
      };
      dirPath = mkOption {
        type = str;
        default = "gitea/conf";
        description = ''
          relative to the path of etc.
          Just like: `/etc/{etc.dirPath}`
        '';
      };
    };
    files = {
      settingsPath = mkMappingOption rec {
        source = "gitea/conf/app.ini";
        target = secrets."${host}/${source}".path;
      };
    };
    owner = mkOption {
      type = str;
      default = "gitea";
      description = "The owner of the files.";
    };
    createOwner = lib.mkEnableOption "auto create gitea owner" // {
      default = !cfgParent.enable && (config.${namespace}.user.name != cfg.owner);
    };
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.shared.secrets.hosts.configFile = {
      "${cfg.files.settingsPath.source}".beneficiary = cfg.owner;
    };

    # etc configuration default path: `/etc/gitea/conf`
    environment.etc = lib.mkIf cfg.etc.enable {
      "${cfg.etc.dirPath}/app.ini" = {
        source = cfg.files.settingsPath.target;
      } // (lib.optionalAttrs (!cfg.etc.useSymlink) onlyOwner);
    };

    users = lib.mkIf cfg.createOwner {
      users.${cfg.owner} = {
        inherit group;
        name = cfg.owner;
        description = "Gitea Service";
        createHome = false;
        useDefaultShell = true;
      };
      groups.${group} = { };
    };
  };
}
