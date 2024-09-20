{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (lib.${namespace}) mkMappingOption;
  inherit (config.age) secrets;

  cfgParent = config.${namespace}.shared.services.sing-box;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.shared.services.sing-box.secrets = with types; {
    enable = lib.mkEnableOption "sing-box" // {
      # If sing-box is started, secrets are enabled by default
      default = cfgParent.enable && config.${namespace}.shared.secrets.enable;
    };
    useSymlinkToEtc = lib.mkEnableOption "use symlink to etc" // {
      default = true;
    };
    dirPathInEtc = mkOption {
      type = str;
      default = "sing-box";
      description = ''
        Symlink is in the etc folder, relative to the path of etc.
        Just like: `/etc/{dirPathInEtc}`
      '';
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
    environment.etc = lib.mkIf cfg.useSymlinkToEtc {
      "${cfg.dirPathInEtc}/config.json" = {
        source = cfg.files.settingsPath.target;
      };
    };
  };
}