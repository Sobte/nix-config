{ pkgs, ... }:
{
  home.packages = with pkgs; [ ulauncher ];

  wayland.windowManager.hyprland = {
    settings = {
      source = [ "${./conf/ulauncher.conf}" ];
    };
  };

  xdg.configFile = {
    # preventing nix gc
    "hypr/ulauncher" = {
      source = ./conf;
      recursive = true;
    };
  };
}
