{ lib, ... }:
rec {
  image.baseName = lib.mkForce "nixos-minimal-new-kernel-${system.stateVersion}-linux";

  # `install-iso` adds wireless support that
  # is incompatible with networkmanager.
  networking.wireless.enable = lib.mkForce false;

  cattery = {
    user = {
      name = "nixos"; # use nixos as default user
      initialHashedPassword = "";
    };
    system.boot.kernel.enable = true;
    room.general.enable = true;
  };

  system.stateVersion = "26.11";
}
