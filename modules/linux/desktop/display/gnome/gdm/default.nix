{
  # GNOME Display Manager
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
}
