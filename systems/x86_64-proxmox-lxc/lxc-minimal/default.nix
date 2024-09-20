{
  namespace,
  ...
}:
{
  ${namespace} = {
    user.name = "root"; # use nixos as default user
    room.container.enable = true;
    system.proxmox.lxc = {
      enable = true;
      manageNetwork = false;
      manageHostName = false;
    };
  };

  system.stateVersion = "24.11";
}