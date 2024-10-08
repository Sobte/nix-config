{
  imports = [ ./hardware.nix ];

  cattery = {
    user.name = "root"; # use root as default user
    room.container.enable = true;
    system.proxmox.lxc.enable = true;
    services.wg-quick.configNames = [ "wg-come-home" ];
  };

  system.stateVersion = "24.11";
}
