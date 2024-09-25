{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types mkForce;

  cfg = config.${namespace}.services.vaultwarden;
in
{
  options.${namespace}.services.vaultwarden = with types; {
    enable = lib.mkEnableOption "vaultwarden";
    dbBackend = lib.mkOption {
      type = enum [
        "sqlite"
        "mysql"
        "postgresql"
      ];
      default = "sqlite";
      description = ''
        Which database backend vaultwarden will be using.
      '';
    };
    configFile = {
      settingsPath = mkOption {
        type = path;
        default = "/etc/vaultwarden/vaultwarden.env";
        description = ''
          config manual ref: <https://github.com/dani-garcia/vaultwarden/blob/main/.env.template>
        '';
      };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      inherit (cfg) dbBackend;
      # override default config
      config = mkForce { };
      environmentFile = cfg.configFile.settingsPath;
    } // cfg.extraOptions;
  };

}
