{
  config,
  lib,
  namespace,
  host,
  ...
}:
let
  inherit (lib) mkOption types mkForce;
  inherit (config.age) secrets;

  cfg = config.${namespace}.services.vaultwarden;

  envPath = secrets."${host}/${cfg.config.path}".path;

  owner = "vaultwarden";
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
    config = {
      path = mkOption {
        type = str;
        default = "vaultwarden/vaultwarden.env";
        description = ''
          config manual ref: <https://github.com/dani-garcia/vaultwarden/blob/main/.env.template>
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.shared.secrets.hosts.configFiles = {
      "${cfg.config.path}".beneficiary = owner;
    };
    services.vaultwarden = {
      enable = true;
      inherit (cfg) dbBackend;
      # override default config
      config = mkForce { };
      environmentFile = envPath;
    };
  };

}
