{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.waybar;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.waybar = {
    enable = lib.mkEnableOption "charm-cat waybar";
  };

  config = lib.mkIf cfg.enable {
    # home manager
    ${namespace}.home.extraOptions = {

      home.packages = with pkgs; [
        # status bar
        waybar
      ];

      wayland.windowManager.hyprland = {
        settings = {
          exec-once = [ "waybar" ];
        };
      };

      xdg.configFile = {
        "waybar" = {
          source = ./conf;
          recursive = true;
        };
      };

    };
  };
}
