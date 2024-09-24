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
  inherit (lib)
    mkOption
    types
    concatMapAttrs
    foldl'
    ;
  inherit (lib.${namespace}) mkMappingOption;
  inherit (config.age) secrets;

  cfgParent = config.${namespace}.services.nginx;
  cfg = cfgParent.secrets;

  onlyOwner = {
    inherit (config.users.users.${cfg.owner}) uid;
    inherit (config.users.groups.${group}) gid;
    # Read-only
    mode = "0440";
  };
  group = "nginx";
in
{
  options.${namespace}.services.nginx.secrets = with types; {
    enable = lib.mkEnableOption "nginx" // {
      # If nginx is started, secrets are enabled by default
      default = cfgParent.enable && config.${namespace}.shared.secrets.enable;
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
        default = "nginx/conf.d";
        description = ''
          relative to the path of etc.
          Just like: `/etc/{etc.dirPath}`
        '';
      };
    };
    configNames = mkOption {
      type = listOf str;
      default = [ ];
    };
    files = foldl' (
      acc: name:
      acc
      // {
        ${name} = mkMappingOption rec {
          source = "nginx/conf.d/${name}.conf";
          target = secrets."${host}/${source}".path;
        };
      }
    ) { } cfg.configNames;
    owner = mkOption {
      type = str;
      default = "nginx";
      description = "The owner of the files.";
    };
    createOwner = lib.mkEnableOption "auto create nginx owner" // {
      default = !cfgParent.enable && (config.${namespace}.user.name != cfg.owner);
    };
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.shared.secrets.hosts.configFile = concatMapAttrs (_: value: {
      "${value.source}".beneficiary = cfg.owner;
    }) cfg.files;

    # etc configuration default path: `/etc/nginx/conf.d`
    environment.etc = lib.mkIf cfg.etc.enable (
      concatMapAttrs (name: value: {
        "${cfg.etc.dirPath}/${name}.conf" = {
          source = value.target;
        } // (lib.optionalAttrs (!cfg.etc.useSymlink) onlyOwner);
      }) cfg.files
    );

    users = lib.mkIf cfg.createOwner {
      users.${cfg.owner} = {
        inherit group;
        isSystemUser = true;
        name = cfg.owner;
        uid = config.ids.uids.nginx;
        description = "nginx web server user";
        createHome = false;
        useDefaultShell = true;
      };
      groups.${group}.gid = config.ids.gids.nginx;
    };
  };
}
