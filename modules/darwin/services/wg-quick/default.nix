{
  pkgs,
  config,
  lib,
  namespace,
  host,
  ...
}:
let
  inherit (lib) mkOption types nameValuePair;

  homeDir = config.users.users.${config.${namespace}.user.name}.home;
  wg-pkgs = pkgs.wireguard-tools;
  cfg = config.${namespace}.services.wg-quick;
in
{
  options.${namespace}.services.wg-quick = with types; {
    enable = lib.mkEnableOption "wireguard wg-quick";
    configNames = mkOption {
      type = listOf str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ wg-pkgs ];
    # secrets
    ${namespace}.shared.secrets.hosts.configFiles = map (name: {
      name = "${name}.conf";
    }) cfg.configNames;
    # wg-quick configuration
    environment.etc = builtins.listToAttrs (
      map (
        name:
        nameValuePair "wireguard/${name}.conf" {
          source = "${config.age.secrets."${host}-${name}.conf".path}";
        }
      ) cfg.configNames
    );
    # launchd
    launchd.daemons = builtins.listToAttrs (
      map (
        name:
        nameValuePair "wg-quick-${name}" {
          serviceConfig = {
            EnvironmentVariables = {
              PATH = "${wg-pkgs}/bin:${config.environment.systemPath}";
            };
            ProgramArguments = [
              "${wg-pkgs}/bin/wg-quick"
              "up"
              "${name}"
            ];
            KeepAlive = {
              NetworkState = true;
              SuccessfulExit = true;
            };
            RunAtLoad = true;
            StandardOutPath = "${homeDir}/Library/Logs/${name}.stdout.log";
            StandardErrorPath = "${homeDir}/Library/Logs/${name}.stderr.log";
          };
        }
      ) cfg.configNames
    );
  };
}
