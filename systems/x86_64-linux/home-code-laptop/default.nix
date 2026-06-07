{
  inputs,
  namespace,
  lib,
  ...
}:
let
  inherit (lib.${namespace}.host.samba) client;
in
{
  imports = [
    # Closest available match.
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p16s-amd-gen1

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
      boot = {
        lanzaboote = {
          enable = true;
          pkiBundle = "/persistent/var/lib/sbctl";
        };
        binfmt.enable = true;
      };
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

  # No driver support for fingerprint reader
  # services.fprintd.enable = true;
  # security.pam.services = {
  #   sudo.fprintAuth = true;
  #   kscreenlocker.fprintAuth = true;
  #   sddm.fprintAuth = false;
  # };
  hardware.enableAllFirmware = true;

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
