{ lib, catteryNs, ... }:
rec {
  image.baseName = lib.mkForce "nixos-minimal-new-kernel-${system.stateVersion}-linux";

  # `install-iso` adds wireless support that
  # is incompatible with networkmanager.
  networking.wireless.enable = lib.mkForce false;

  ${catteryNs} = {
    user = {
      name = "nixos"; # use nixos as default user
      initialHashedPassword = "";
    };
    system.boot.kernel = {
      useLatestZfsCompatible = true;
    };
    room.general.enable = true;
  };

  system.stateVersion = "26.11";
}
