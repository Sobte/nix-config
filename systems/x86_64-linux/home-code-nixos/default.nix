{ config, namespace, ... }:
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    room.desktop.dev.enable = true;
    desktop.kde.enable = true;

    system.fileSystems = {
      home-nas.enable = true;
    };
  };

  # wg-quick configuration
  networking.wg-quick.interfaces = {
    wg-come-home = {
      # TODO use hosts-secrets (garnix no cache secrets)
      configFile = "${
        config.users.users.${config.${namespace}.user.name}.home
      }/.config/hosts-secrets/hosts/home-code-nixos/wg-come-home.conf";
    };
  };

  # krdp ports
  networking.firewall =
    let
      ports = [ 6630 ];
    in
    {
      allowedUDPPorts = ports;
      allowedTCPPorts = ports;
    };

  system.stateVersion = "24.05";

}
