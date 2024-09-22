{ namespace, ... }:
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    user.name = "root"; # use root as default user
    room.container.enable = true;
    system.proxmox.lxc.enable = true;
    services = {
      vscode-server.enable = true;
      postgresql = {
        enable = true;
        extraOptions = {
          ensureDatabases = [ "vaultwarden" ];
          ensureUsers = [
            {
              name = "vaultwarden";
              ensureDBOwnership = true;
            }
          ];
        };
      };
      vaultwarden = {
        enable = true;
        dbBackend = "postgresql";
      };
    };
  };

  system.stateVersion = "24.05";
}
