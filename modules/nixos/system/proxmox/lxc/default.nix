{
  config,
  lib,
  namespace,
  modulesPath,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.system.proxmox.lxc;
in
{
  imports = [
    # proxmox lxc
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  options.${namespace}.system.proxmox.lxc = {
    enable = lib.mkEnableOption "proxmox lxc";
    manageNetwork = mkOption {
      type = types.bool;
      default = true;
    };
    manageHostName = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = {
    # lxc config
    proxmoxLXC = {
      inherit (cfg) enable manageNetwork manageHostName;
    };
  };

}
