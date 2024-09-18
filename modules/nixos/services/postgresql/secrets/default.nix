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

  cfgParent = config.${namespace}.services.postgresql;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.services.postgresql.secrets = with types; {
    enable = lib.mkEnableOption "postgresql" // {
      # If postgresql is started, secrets are enabled by default
      default = cfgParent.enable;
    };
    useSymlinkToEtc = lib.mkEnableOption "use symlink to etc" // {
      default = true;
    };
    files = {
      settingsPath = mkMappingOption rec {
        source = "postgresql/postgresql.conf";
        target = secrets."${host}/${source}".path;
      };
      identMapPath = mkMappingOption rec {
        source = "postgresql/pg_ident.conf";
        target = secrets."${host}/${source}".path;
      };
      authenticationPath = mkMappingOption rec {
        source = "postgresql/pg_hba.conf";
        target = secrets."${host}/${source}".path;
      };
    };
    owner = mkOption {
      type = str;
      default = "postgres";
      description = "The owner of the files.";
    };
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.shared.secrets.hosts.configFile = {
      "${cfg.files.settingsPath.source}".beneficiary = cfg.owner;
      "${cfg.files.identMapPath.source}".beneficiary = cfg.owner;
      "${cfg.files.authenticationPath.source}".beneficiary = cfg.owner;
    };

    # etc configuration path: `/etc/postgresql`
    environment.etc = lib.mkIf cfg.useSymlinkToEtc {
      "postgresql/postgresql.conf" = {
        source = cfg.files.settingsPath.target;
      };
      "postgresql/pg_ident.conf" = {
        source = cfg.files.identMapPath.target;
      };
      "postgresql/pg_hba.conf" = {
        source = cfg.files.authenticationPath.target;
      };
    };
  };
}
