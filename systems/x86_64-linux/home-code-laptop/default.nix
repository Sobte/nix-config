{
  namespace,
  lib,
  ...
}:
let
  inherit (lib.${namespace}.host.samba) client;
in
{
  imports = [
    ./hardware.nix
    # ./disk.nix
  ];

  cattery = {
    nix.secrets.enable = true;
    apps = {
      winbox = {
        enable = true;
        openFirewall = true;
      };
      game.gale.enable = true;
    };
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
      wg-quick.configNames = [ "wg-go-home" ];
      tailscale.enable = true;
      openssh.settings = {
        StreamLocalBindUnlink = true;
      };
    };
  };

  # krdp ports
  networking.firewall =
    let
      ports = [
        6630
        80
        443
      ];
    in
    {
      allowedUDPPorts = ports;
      allowedTCPPorts = ports;
    };

  system.stateVersion = "26.11";
}
