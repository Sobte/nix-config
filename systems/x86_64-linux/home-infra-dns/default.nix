{ namespace, ... }:
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    user.name = "root"; # use root as default user
    room.container.enable = true;
    system.proxmox.lxc.enable = true;
    services = {
      smartdns.enable = true;
      vscode-server.enable = true;
    };
  };

  system.stateVersion = "24.11";
}
