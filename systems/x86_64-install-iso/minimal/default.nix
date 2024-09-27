{
  pkgs,
  lib,
  namespace,
  ...
}:
{
  isoImage.isoBaseName = "nixos-minimal-new-kernel";

  # `install-iso` adds wireless support that
  # is incompatible with networkmanager.
  networking.wireless.enable = lib.mkForce false;
  # use the latest zfs
  boot.zfs.package = pkgs.zfs_unstable;

  ${namespace} = {
    user.name = "nixos"; # use nixos as default user
    system.kernel.enable = true;
    room.general.enable = true;
  };

  system.stateVersion = "24.11";
}
