{
  config,
  lib,
  namespace,
  catteryNs,
  ...
}:
let
  cfg = config.${namespace}.containerLxc;
in
{
  options.${namespace}.containerLxc = {
    enable = lib.mkEnableOption "proxmox lxc container host" // {
      description = ''
        Set up a root-user Proxmox LXC container host: root as default user,
        room.container enabled and Proxmox LXC support. Combines the
        `user.name = "root"` + `room.container` + `system.proxmox.lxc` trio
        that container hosts share.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    ${catteryNs} = {
      user.name = "root"; # use root as default user
      room.container.enable = true;
      system.proxmox.lxc.enable = true;
    };
  };
}
