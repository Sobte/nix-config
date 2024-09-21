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

  onlyOwner = {
    inherit (config.users.users.${cfg.owner}) uid;
    inherit (config.users.groups.postgres) gid;
    # Read-only
    mode = "0400";
  };
in
{
  options.${namespace}.services.postgresql.secrets = with types; {
    enable = lib.mkEnableOption "postgresql" // {
      # If postgresql is started, secrets are enabled by default
      default = cfgParent.enable && config.${namespace}.shared.secrets.enable;
    };
    etc = {
      enable = lib.mkEnableOption "bind to etc" // {
        default = true;
      };
      useSymlink = lib.mkEnableOption "use symlink to etc" // {
        default = false;
      };
      dirPath = mkOption {
        type = str;
        default = "postgresql";
        description = ''
          relative to the path of etc.
          Just like: `/etc/{etc.dirPath}`
        '';
      };
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
    environment.etc = lib.mkIf cfg.etc.enable {
      "${cfg.etc.dirPath}/postgresql.conf" = {
        source = cfg.files.settingsPath.target;
      } // (lib.optionalAttrs (!cfg.etc.useSymlink) onlyOwner);
      "${cfg.etc.dirPath}/pg_ident.conf" = {
        source = cfg.files.identMapPath.target;
      } // (lib.optionalAttrs (!cfg.etc.useSymlink) onlyOwner);
      "${cfg.etc.dirPath}/pg_hba.conf" = {
        source = cfg.files.authenticationPath.target;
      } // (lib.optionalAttrs (!cfg.etc.useSymlink) onlyOwner);
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
