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
      default = cfgParent.enable && config.${namespace}.shared.secrets.enable;
    };
    useSymlinkToEtc = lib.mkEnableOption "use symlink to etc" // {
      default = true;
    };
    dirPathInEtc = mkOption {
      type = str;
      default = "vaultwarden";
      description = ''
        Symlink is in the etc folder, relative to the path of etc.
        Just like: `/etc/{dirPathInEtc}`
      '';
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
    environment.etc = lib.mkIf cfg.useSymlinkToEtc {
      "${cfg.dirPathInEtc}/vaultwarden.env" = {
        source = cfg.files.settingsPath.target;
      };
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
