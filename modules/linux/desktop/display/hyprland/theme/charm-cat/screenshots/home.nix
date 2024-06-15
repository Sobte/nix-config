{ pkgs, ... }:
{
  imports = [ ../../../hyprshot/home.nix ];

  home.packages = with pkgs; [
    nomacs # image viewer
  ];

  wayland.windowManager.hyprland = {
    settings = {
      source = [ "${./conf/screenshots.conf}" ];
    };
  };

  xdg.configFile = {
    # preventing nix gc
    "hypr/screenshots" = {
      source = ./conf;
      recursive = true;
    };
  };
}
