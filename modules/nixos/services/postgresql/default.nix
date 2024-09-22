{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types mkForce;

  cfg = config.${namespace}.services.postgresql;
in
{
  options.${namespace}.services.postgresql = with types; {
    enable = lib.mkEnableOption "postgresql";
    openFirewall = lib.mkEnableOption "postgresql open firewall";
    configFile = {
      settingsPath = mkOption {
        type = path;
        default = "/etc/postgresql/postgresql.conf";
        description = ''
          except for options defined here: 
          <https://search.nixos.org/options?query=services.postgresql.settings>

          which cannot be overwritten, all others are subject to the file.

          options that cannot be overwritten have been moved to `${namespace}.services.postgresql.settings`.
        '';
      };
      identMapPath = mkOption {
        type = path;
        default = "/etc/postgresql/pg_ident.conf";
      };
      authenticationPath = mkOption {
        type = path;
        default = "/etc/postgresql/pg_hba.conf";
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
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.port ];
    };
    # postgresql
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
      settings = mkForce (
        {
          hba_file = cfg.configFile.authenticationPath;
          ident_file = cfg.configFile.identMapPath;
          include_if_exists = cfg.configFile.settingsPath;
        }
        // cfg.settings
      );
    } // cfg.extraOptions;
  };
}
