{
  namespace,
  lib,
  ...
}:
let
  inherit (lib.${namespace}.host.samba) clients;
in
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    room.desktop.dev.enable = true;
    desktop.kde.enable = true;

    system.fileSystems.samba = {
      enable = true;
      inherit clients;
    };
    services.wg-quick = {
      enable = true;
      configNames = [ "wg-come-home" ];
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
