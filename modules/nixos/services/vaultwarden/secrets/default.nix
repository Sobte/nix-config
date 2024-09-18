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
in
{
  options.${namespace}.services.vaultwarden.secrets = with types; {
    enable = lib.mkEnableOption "vaultwarden" // {
      # If vaultwarden is started, secrets are enabled by default
      default = cfgParent.enable;
    };
    useSymlinkToEtc = lib.mkEnableOption "use symlink to etc" // {
      default = true;
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

    # etc configuration path: `/etc/vaultwarden`
    environment.etc = lib.mkIf cfg.useSymlinkToEtc {
      "vaultwarden/vaultwarden.env" = {
        source = cfg.files.settingsPath.target;
      };
    };
  };
}
