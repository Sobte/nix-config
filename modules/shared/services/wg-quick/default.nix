{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (lib)
    mkOption
    types
    nameValuePair
    ;

  cfg = config.${namespace}.shared.services.wg-quick;

  homeDir = config.${namespace}.user.home;
  wg-pkgs = pkgs.wireguard-tools;
  prefix = "/etc/wireguard";
in
{
  options.${namespace}.shared.services.wg-quick = with types; {
    enable = lib.mkEnableOption "wireguard wg-quick" // {
      default = (builtins.length cfg.configNames) > 0;
    };
    configPrefix = mkOption {
      type = str;
      default = prefix;
      readOnly = true;
    };
    configNames = mkOption {
      type = listOf str;
      default = [ ];
      description = "List of configuration names in the `${prefix}` path, no suffix";
    };
  };

  config = lib.mkIf cfg.enable (
    {
      environment.systemPackages = [ wg-pkgs ];
    }
    // (lib.optionalAttrs isDarwin {
      # mac launchd
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
              StandardOutPath = "${homeDir}/Library/Logs/wg-quick-${name}.stdout.log";
              StandardErrorPath = "${homeDir}/Library/Logs/wg-quick-${name}.stderr.log";
            };
          }
        ) cfg.configNames
      );
    })
    // (lib.optionalAttrs isLinux {
      # wg-quick configuration
      networking.wg-quick.interfaces = builtins.listToAttrs (
        map (
          name:
          nameValuePair name {
            configFile = "${cfg.configPrefix}/${name}.conf";
          }
        ) cfg.configNames
      );
    })
  );
}
