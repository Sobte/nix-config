{
  config,
  lib,
  namespace,
  host,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (lib.${namespace}) mkMappingOption;
  inherit (config.age) secrets;

  cfgParent = config.${namespace}.services.vaultwarden;
  cfg = cfgParent.secrets;

  onlyOwner = {
    inherit (config.users.users.${cfg.owner}) uid;
    inherit (config.users.groups.vaultwarden) gid;
    # Read-only
    mode = "0400";
  };
in
{
  options.${namespace}.services.vaultwarden.secrets = with types; {
    enable = lib.mkEnableOption "vaultwarden" // {
      # If vaultwarden is started, secrets are enabled by default
      default = cfgParent.enable && config.${namespace}.shared.secrets.enable;
    };
    etc = {
      enable = lib.mkEnableOption "bind to etc" // {
        default = true;
      };
      useSymlink = lib.mkEnableOption "use symlink to etc" // {
        default = false;
      };
      dirPath = mkOption {
        type = str;
        default = "vaultwarden";
        description = ''
          relative to the path of etc.
          Just like: `/etc/{etc.dirPath}`
        '';
      };
    };
    files = {
      settingsPath = mkMappingOption rec {
        source = "vaultwarden/vaultwarden.env";
        target = secrets."${host}/${source}".path;
      };
    };
    owner = mkOption {
      type = str;
      default = "vaultwarden";
      description = "The owner of the files.";
    };
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.shared.secrets.hosts.configFile = {
      "${cfg.files.settingsPath.source}".beneficiary = cfg.owner;
    };

    # etc configuration default path: `/etc/vaultwarden`
    environment.etc = lib.mkIf cfg.etc.enable {
      "${cfg.etc.dirPath}/vaultwarden.env" = {
        source = cfg.files.settingsPath.target;
      } // (lib.optionalAttrs (!cfg.etc.useSymlink) onlyOwner);
    };

    users = lib.mkIf (!cfgParent.enable) {
      users.${cfg.owner} = {
        name = cfg.owner;
        group = "vaultwarden";
        description = "Vaultwarden server user";
        createHome = false;
        useDefaultShell = true;
      };
      groups.vaultwarden = { };
    };
  };
}
