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
      default = cfgParent.enable && config.${namespace}.shared.secrets.enable;
    };
    useSymlinkToEtc = lib.mkEnableOption "use symlink to etc" // {
      default = true;
    };
    dirPathInEtc = mkOption {
      type = str;
      default = "postgresql";
      description = ''
        Symlink is in the etc folder, relative to the path of etc.
        Just like: `/etc/{dirPathInEtc}`
      '';
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

    # etc configuration default path: `/etc/postgresql`
    environment.etc = lib.mkIf cfg.useSymlinkToEtc {
      "${cfg.dirPathInEtc}/postgresql.conf" = {
        source = cfg.files.settingsPath.target;
      };
      "${cfg.dirPathInEtc}/pg_ident.conf" = {
        source = cfg.files.identMapPath.target;
      };
      "${cfg.dirPathInEtc}/pg_hba.conf" = {
        source = cfg.files.authenticationPath.target;
      };
    };

    users = lib.mkIf (!cfgParent.enable) {
      users.${cfg.owner} = {
        name = cfg.owner;
        uid = config.ids.uids.postgres;
        group = "postgres";
        description = "PostgreSQL server user";
        createHome = false;
        useDefaultShell = true;
      };
      groups.postgres.gid = config.ids.gids.postgres;
    };
  };
}
