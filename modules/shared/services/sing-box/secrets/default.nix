{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkOption types;
  inherit (lib.${namespace}) mkMappingOption;
  inherit (config.age) secrets;

  cfgParent = config.${namespace}.shared.services.sing-box;
  cfg = cfgParent.secrets;

  onlyOwner = {
    inherit (config.users.users.${cfg.owner}) uid;
    # Read-only
    mode = "0400";
  };
in
{
  options.${namespace}.shared.services.sing-box.secrets = with types; {
    enable = lib.mkEnableOption "sing-box" // {
      # If sing-box is started, secrets are enabled by default
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
        default = "sing-box";
        description = ''
          relative to the path of etc.
          Just like: `/etc/{etc.dirPath}`
        '';
      };
    };
    files = {
      settingsPath = mkMappingOption rec {
        source = "config.json";
        target = secrets."sing-box/${source}".path;
      };
    };
    owner = mkOption {
      type = str;
      default = "root";
      description = "The owner of the files.";
    };
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.shared.secrets.shared.sing-box.configFile = {
      "${cfg.files.settingsPath.source}".beneficiary = cfg.owner;
    };

    # etc configuration default path: `/etc/sing-box`
    environment.etc = lib.mkIf cfg.etc.enable {
      "${cfg.etc.dirPath}/config.json" = {
        source = cfg.files.settingsPath.target;
      } // (lib.optionalAttrs (!cfg.etc.useSymlink) onlyOwner);
    };
  };
}
