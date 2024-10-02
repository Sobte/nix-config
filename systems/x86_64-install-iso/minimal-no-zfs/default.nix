{ lib, ... }:
{
  isoImage.isoBaseName = "nixos-minimal-new-kernel-no-zfs";

  # `install-iso` adds wireless support that
  # is incompatible with networkmanager.
  networking.wireless.enable = lib.mkForce false;
  # close zfs
  boot.supportedFilesystems.zfs = lib.mkForce false;
  boot.initrd.supportedFilesystems.zfs = lib.mkForce false;

  cattery = {
    user.name = "nixos"; # use nixos as default user
    system.boot.kernel.enable = true;
    room.general.enable = true;
  };

  system.stateVersion = "24.11";
}
