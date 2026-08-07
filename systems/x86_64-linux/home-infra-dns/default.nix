{ catteryNs, ... }:
{
  imports = [ ./hardware.nix ];

  ${catteryNs} = {
    user.name = "root"; # use root as default user
    room.container.enable = true;
    system.proxmox.lxc.enable = true;
    services = {
      smartdns.enable = true;
      vscode-server.enable = true;
    };
  };

  system.stateVersion = "26.11";
}
