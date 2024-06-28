{ modulesPath, ... }:
{
  imports = [
    ../../modules/linux/container.nix
    # proxmox lxc
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    # vscode server
    ../../modules/linux/packages/core/services/vscode-server.nix
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];

  # lxc config
  proxmoxLXC = {
    manageNetwork = true;
    manageHostName = true;
  };
}
