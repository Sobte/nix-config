{ lib, catteryNs, ... }:
{
  networking.hostName = lib.mkForce "";
  ${catteryNs} = {
    user.name = "root"; # use nixos as default user
    room.server = {
      enable = true;
      cloud-init = {
        enable = true;
      };
    };
    system.boot.efi.enable = false;
  };
}
