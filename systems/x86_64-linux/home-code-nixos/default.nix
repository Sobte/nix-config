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
    room.desktop = {
      dev.enable = true;
      game.enable = true;
    };
    desktop = {
      addons.catppuccin.enable = true;
      plasma.enable = true;
    };
    # use hashedPasswordFile
    user.useSecretPasswordFile = true;

    system = {
      boot.binfmt.enable = true;
      impermanence.enable = true;
      fileSystems.samba = {
        enable = true;
        inherit client;
      };
    };
    services = {
      wg-quick.configNames = [ "wg-come-home" ];
      tailscale.enable = true;
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

  system.stateVersion = "25.05";
}
