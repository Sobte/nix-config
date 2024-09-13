{
  config,
  pkgs,
  lib,
  namespace,
  host,
  ...
}:
let
  inherit (lib) mkOption types mkForce;
  inherit (config.age) secrets;

  cfg = config.${namespace}.services.postgresql;

  confgPath = secrets."${host}/${cfg.config.path}".path;
  identMapPath = secrets."${host}/${cfg.config.identMapPath}".path;
  authenticationPath = secrets."${host}/${cfg.config.authenticationPath}".path;

  owner = "postgres";
in
{
  options.${namespace}.services.postgresql = with types; {
    enable = lib.mkEnableOption "postgresql";
    config = {
      path = mkOption {
        type = str;
        default = "postgresql/postgresql.conf";
        description = ''
          except for options defined here: 
          <https://search.nixos.org/options?query=services.postgresql.settings>

          which cannot be overwritten, all others are subject to the file.

          options that cannot be overwritten have been moved to `${namespace}.services.postgresql.settings`.
        '';
      };
      identMapPath = mkOption {
        type = str;
        default = "postgresql/pg_ident.conf";
      };
      authenticationPath = mkOption {
        type = str;
        default = "postgresql/pg_hba.conf";
      };
    };
    settings = {
      shared_preload_libraries = mkOption {
        type = nullOr (coercedTo (listOf str) (concatStringsSep ", ") str);
        default = null;
        example = literalExpression ''[ "auto_explain" "anon" ]'';
        description = ''List of libraries to be preloaded. '';
      };
      log_line_prefix = mkOption {
        type = types.str;
        default = "%q%r ";
        example = "%q[%r]%u@%d%a ";
        description = ''Ref: <https://www.postgresql.org/docs/current/runtime-config-logging.html#GUC-LOG-LINE-PREFIX>.'';
      };
      port = mkOption {
        type = types.port;
        default = 5432;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.shared.secrets.hosts.configFiles = {
      "${cfg.config.path}".beneficiary = owner;
      "${cfg.config.identMapPath}".beneficiary = owner;
      "${cfg.config.authenticationPath}".beneficiary = owner;
    };
    # postgresql
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
      settings = mkForce (
        {
          hba_file = authenticationPath;
          ident_file = identMapPath;
          include_if_exists = confgPath;
        }
        // cfg.settings
      );
    };
  };
}
