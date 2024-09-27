{
  pkgs,
  lib,
  namespace,
  ...
}:
{
  isoImage.isoBaseName = "nixos-plasma6-new-kernel";

  # `install-iso` adds wireless support that
  # is incompatible with networkmanager.
  networking.wireless.enable = lib.mkForce false;
  # use the latest zfs
  boot.zfs.package = pkgs.zfs_unstable;

  ${namespace} = {
    user.name = "nixos"; # use nixos as default user
    # plasma6
    desktop.kde.enable = true;
    system.kernel.enable = true;
    room.desktop.general.enable = true;
  };

  system.stateVersion = "24.11";
}
