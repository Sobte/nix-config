{ lib, ... }:
{
  isoImage.isoBaseName = "nixos-plasma6-new-kernel";

  # `install-iso` adds wireless support that
  # is incompatible with networkmanager.
  networking.wireless.enable = lib.mkForce false;

  cattery = {
    user.name = "nixos"; # use nixos as default user
    # plasma6
    desktop.kde.enable = true;
    system.boot.kernel.enable = true;
    room.desktop.general.enable = true;
  };

  system.stateVersion = "24.11";
}
