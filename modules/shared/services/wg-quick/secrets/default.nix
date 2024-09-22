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

  cfgParent = config.${namespace}.shared.services.wg-quick;
  cfg = cfgParent.secrets;

  onlyOwner = {
    inherit (config.users.users.${cfg.owner}) uid;
    # Read-only
    mode = "0400";
  };
in
{
  options.${namespace}.shared.services.wg-quick.secrets = with types; {
    enable = lib.mkEnableOption "wg-quick" // {
      # If wg-quick is started, secrets are enabled by default
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
        default = "wireguard";
        description = ''
          relative to the path of etc.
          Just like: `/etc/{etc.dirPath}`
        '';
      };
    };
    configNames = mkOption {
      type = listOf str;
      default = cfgParent.configNames;
    };
    files = foldl' (
      acc: name:
      acc
      // {
        ${name} = mkMappingOption rec {
          source = "wireguard/${name}.conf";
          target = secrets."${host}/${source}".path;
        };
      }
    ) { } cfg.configNames;
    owner = mkOption {
      type = str;
      default = "root";
      description = "The owner of the files.";
    };
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.shared.secrets.hosts.configFile = concatMapAttrs (_: value: {
      "${value.source}".beneficiary = cfg.owner;
    }) cfg.files;

    # etc configuration default path: `/etc/wireguard`
    environment.etc = lib.mkIf cfg.etc.enable (
      concatMapAttrs (name: value: {
        "${cfg.etc.dirPath}/${name}.conf" = {
          source = value.target;
        } // (lib.optionalAttrs (!cfg.etc.useSymlink) onlyOwner);
      }) cfg.files
    );
  };
}
