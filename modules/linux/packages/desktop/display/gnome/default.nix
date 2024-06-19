{
  imports = [
    ../xorg.nix
    ./gdm
  ];

  services.xserver = {
    desktopManager.gnome.enable = true;
  };
}
