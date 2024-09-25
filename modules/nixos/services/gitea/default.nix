{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.gitea;
in
{
  options.${namespace}.services.gitea = with types; {
    enable = lib.mkEnableOption "gitea";
    dbBackend = mkOption {
      type = enum [
        "sqlite"
        "mysql"
        "postgresql"
      ];
      default = "sqlite";
      description = "To run gitea after database service.";
    };
    useWizard = mkOption {
      type = bool;
      default = true;
    };
    configFile = {
      settingsPath = mkOption {
        type = path;
        default = "${config.services.gitea.customDir}/conf/app.ini";
        readOnly = true;
        description = ''
          config manual ref: <https://docs.gitea.com/administration/config-cheat-sheet>
        '';
      };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.gitea = {
      inherit (cfg) enable useWizard;
      database.type =
        if cfg.dbBackend == "sqlite" then
          "sqlite3"
        else
          (if cfg.dbBackend == "postgresql" then "postgres" else cfg.dbBackend);
    } // cfg.extraOptions;
  };
}
