{
  imports = [
    ../../xorg.nix
    ./gdm
  ];

  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
