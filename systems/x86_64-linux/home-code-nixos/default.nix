{
  namespace,
  lib,
  ...
}:
let
  inherit (lib.${namespace}.host.samba) client;
in
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    room.desktop.dev.enable = true;
    desktop.kde.enable = true;

    system.fileSystems.samba = {
      enable = true;
      inherit client;
    };
    shared.services.wg-quick.configNames = [ "wg-come-home" ];
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
