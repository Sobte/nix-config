{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.wlogout;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.wlogout = {
    enable = lib.mkEnableOption "charm-cat wlogout";
  };

  config = lib.mkIf cfg.enable {
    # home manager
    ${namespace}.home.extraOptions = {

      home.packages = with pkgs; [
        wlogout # logout menu
      ];

      wayland.windowManager.hyprland = {
        settings = {
          source = [ "${./conf/hypr-wlogout.conf}" ];
        };
      };

      xdg.configFile = {
        "wlogout" = {
          source = ./conf;
          recursive = true;
        };
      };

    };
  };
}
