{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types mkBefore;

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
    useWizard = lib.mkEnableOption "gitea use host config";
    configFile = {
      settingsPath = mkOption {
        type = path;
        default = "/etc/gitea/conf/app.ini";
        description = ''
          If useWizard is enabled, the config files 
          will be copied to ${config.services.gitea.customDir}.
          config manual ref: <https://docs.gitea.com/administration/config-cheat-sheet>
        '';
      };
    };
    settings = mkOption {
      type = attrs;
      default = { };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.gitea = {
      inherit (cfg) enable useWizard settings;
      database.type =
        if cfg.dbBackend == "sqlite" then
          "sqlite3"
        else
          (if cfg.dbBackend == "postgresql" then "postgres" else cfg.dbBackend);
    } // cfg.extraOptions;

    systemd.services.gitea = lib.mkIf cfg.useWizard (
      let
        configFile = "${cfg.configFile.settingsPath}";
        runConfig = "${config.services.gitea.customDir}/conf/app.ini";
        pathConfig = "${config.services.gitea.customDir}/conf/rootPath";
        staticRootPath = config.services.gitea.settings.server.STATIC_ROOT_PATH;
        replaceSecretBin = "${pkgs.replace-secret}/bin/replace-secret";
      in
      {
        preStart = mkBefore ''
          function gitea_custom_config {
            if [ -s '${configFile}' ]; then
              cp -f '${configFile}' '${runConfig}'
              chmod u+w '${runConfig}'
              echo '${staticRootPath}' > '${pathConfig}'
              ${replaceSecretBin} '#staticRootPath#' '${pathConfig}' '${runConfig}'
              rm -f '${pathConfig}'
              chmod u-w '${runConfig}'
            fi
          }
          (umask 027; gitea_custom_config)
        '';
      }
    );
  };
}
