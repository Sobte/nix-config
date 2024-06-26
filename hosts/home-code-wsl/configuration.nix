{ lib, ... }:
{
  imports = [
    ../../modules/linux/general-desktop.nix
    # gnome
    ../../modules/linux/packages/desktop/display/gnome
    # home samba
    ../../modules/linux/packages/core/services/samba.nix
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];
  # close wsl linux docker
  virtualisation.docker.enable = lib.mkForce false;
}
