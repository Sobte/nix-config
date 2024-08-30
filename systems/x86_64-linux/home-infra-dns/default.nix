{ namespace, ... }:
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    room.container.enable = true;
    system.proxmox.lxc.enable = true;
    services = {
      smartdns.enable = true;
      vscode-server.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
