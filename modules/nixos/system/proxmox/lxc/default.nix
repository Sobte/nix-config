{
  config,
  lib,
  namespace,
  modulesPath,
  ...
}:
let
  cfg = config.${namespace}.system.proxmox.lxc;
in
{
  imports = [
    # proxmox lxc
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  options.${namespace}.system.proxmox.lxc = {
    enable = lib.mkEnableOption "proxmox lxc";
  };

  config = {
    # lxc config
    proxmoxLXC = {
      inherit (cfg) enable;
      manageNetwork = cfg.enable;
      manageHostName = cfg.enable;
    };
  };

}
