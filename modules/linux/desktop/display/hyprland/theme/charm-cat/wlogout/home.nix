{ pkgs, ... }:
{
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
}
