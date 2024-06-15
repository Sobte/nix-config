{ pkgs, ... }:
{
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
}
