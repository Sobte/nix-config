{
  imports = [ ../../../../../app/thunar-home.nix ];
  wayland.windowManager.hyprland = {
    settings = {
      # Xfce Thunar
      bind = [ "SUPER,E,exec,thunar" ];
    };
  };
}
