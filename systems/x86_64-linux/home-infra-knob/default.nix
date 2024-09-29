{ namespace, ... }:
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    user.name = "root"; # use root as default user
    room.container.enable = true;
    system.proxmox.lxc.enable = true;
    shared.services.wg-quick.configNames = [ "wg-come-home" ];
  };

  system.stateVersion = "24.11";
}
