{
  namespace,
  lib,
  catteryNs,
  inputs,
  host,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.host.samba) client;
in
{
  imports = [ ./hardware.nix ];

  ${catteryNs} = {
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
      fonts.extraPackages = [ pkgs.windows11-fonts ];
    };
    services = {
      wg-quick.configNames = inputs.hosts-secrets.lib.settings.wireguard.configNames.${host} or [ ];
      tailscale.enable = true;
      openssh.settings = {
        StreamLocalBindUnlink = true;
      };
    };
  };

  # local-send
  programs.localsend = {
    enable = true;
  };

  # krdp ports
  ${namespace}.firewall.ports = [
    6630
    80
    443
  ];

}
