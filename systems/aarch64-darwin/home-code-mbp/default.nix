{
  pkgs,
  inputs,
  config,
  namespace,
  ...
}:
let
  homeDir = config.users.users.${config.${namespace}.user.name}.home;
in
{
  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ pkgs.wireguard-tools ];

  environment.etc = {
    # wg-quick configuration
    "wireguard/wg-go-home.conf" = {
      source = "${inputs.hosts-secrets}/hosts/home-code-mbp/wg-go-home.conf";
    };
    # sing-box configuration
    "sing-box/config.json" = {
      source = "${inputs.hosts-secrets}/shared/sing-box/config.json";
    };
  };

  # launchd
  launchd.daemons = {
    "wg-quick-wg-go-home" = {
      serviceConfig = {
        EnvironmentVariables = {
          PATH = "${pkgs.wireguard-tools}/bin:${config.environment.systemPath}";
        };
        ProgramArguments = [
          "${pkgs.wireguard-tools}/bin/wg-quick"
          "up"
          "wg-go-home"
        ];
        KeepAlive = {
          NetworkState = true;
          SuccessfulExit = true;
        };
        RunAtLoad = true;
        StandardOutPath = "${homeDir}/Library/Logs/wg-go-home.stdout.log";
        StandardErrorPath = "${homeDir}/Library/Logs/wg-go-home.stderr.log";
      };
    };
  };

  ${namespace}.room.desktop.dev = {
    enable = true;
  };
}
