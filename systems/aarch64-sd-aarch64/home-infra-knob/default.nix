{ inputs, ... }:
{
  imports = with inputs; [
    nixos-hardware.nixosModules.friendlyarm-nanopi-r5s
  ];

  cattery = {
    user.name = "root"; # use root as default user
    room.server.enable = true;
    system.boot.efi.enable = false;
    shared.services.wg-quick.configNames = [ "wg-come-home" ];
  };

  system.stateVersion = "24.11";
}
