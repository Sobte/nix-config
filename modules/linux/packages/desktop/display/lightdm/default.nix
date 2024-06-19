{
  imports = [ ../xorg.nix ];
  services.xserver.displayManager.lightdm.enable = true;
}
