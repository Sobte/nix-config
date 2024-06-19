{
  wayland.windowManager.hyprland = {
    settings = {
      source = [ "${./conf/fcitx.conf}" ];
    };
  };

  xdg.configFile = {
    # preventing nix gc
    "hypr/fcitx" = {
      source = ./conf;
      recursive = true;
    };
  };
}
