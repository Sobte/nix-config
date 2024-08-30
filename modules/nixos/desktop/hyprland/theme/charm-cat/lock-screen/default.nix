{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.lock-screen;
  lockCmd = "pidof hyprlock || hyprlock";
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.lock-screen = {
    enable = lib.mkEnableOption "charm-cat lock screen";
  };

  config = lib.mkIf cfg.enable {

    ${namespace} = {
      # hyprlock and hypridle
      desktop.hyprland.addons = {
        hyprlock = mkDefaultEnabled;
        hypridle = mkDefaultEnabled;
      };

      # home manager
      home.extraOptions = {
        # hyprlock
        programs.hyprlock = {
          settings = {
            source = [ "${./conf/hyprlock.conf}" ];
          };
        };

        # hypridle
        services.hypridle = {
          settings = {
            general = {
              lock_cmd = lockCmd;
              before_sleep_cmd = lockCmd;
            };

            listener = [
              # listener conf 1
              {
                timeout = 180; # 3mins
                on-timeout = lockCmd;
              }
              # listener conf 2
              {
                timeout = 240; # 4mins
                # sets all monitors’ DPMS status
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }
            ];
          };
        };

        wayland.windowManager.hyprland = {
          settings = {
            bind = [
              "CTRLALT,L,exec,${lockCmd}" # network-manager-applet
            ];
          };
        };

        xdg.configFile = {
          # preventing nix gc
          "hypr/lock-screen" = {
            source = ./conf;
            recursive = true;
          };
        };
      };
    };

  };
}
