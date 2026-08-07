{ inputs, catteryNs, ... }:
{
  imports = with inputs; [
    nixos-hardware.nixosModules.friendlyarm-nanopi-r5s
  ];

  ${catteryNs} = {
    user.name = "root"; # use root as default user
    room.server.enable = true;
    system.boot.efi.enable = false;
    services.wg-quick.configNames = [ "wg-come-home" ];
  };

  system.stateVersion = "26.11";
}
