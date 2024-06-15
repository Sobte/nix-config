{
  wayland.windowManager.hyprland = {
    settings = {
      source = [
        "${./conf/base.conf}"
        "${./conf/bind-operate.conf}"
        "${./conf/monitor.conf}"
        "${./conf/rules.conf}"
        "${./conf/style.conf}"
      ];
    };
  };

  xdg.configFile = {
    # preventing nix gc
    "hypr/convention" = {
      source = ./conf;
      recursive = true;
    };
  };
}
