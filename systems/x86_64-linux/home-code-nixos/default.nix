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

  cattery = {
    room.desktop.dev.enable = true;
    desktop.kde.enable = true;

    system = {
      boot.binfmt.enable = true;
      fileSystems.samba = {
        enable = true;
        inherit client;
      };
    };
    services.wg-quick.configNames = [ "wg-come-home" ];
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

  system.stateVersion = "24.11";
}
