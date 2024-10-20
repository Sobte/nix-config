{
  imports = [ ./hardware.nix ];

  cattery = {
    user.name = "root"; # use root as default user
    room.container.enable = true;
    system.proxmox.lxc.enable = true;
  };

  system.stateVersion = "24.11";
}
