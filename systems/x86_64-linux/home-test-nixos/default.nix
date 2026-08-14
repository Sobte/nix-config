{
  namespace,
  lib,
  inputs,
  host,
  catteryNs,
  ...
}:
let
  inherit (lib.${namespace}.host.samba) client;
in
{
  imports = [ ./hardware.nix ];

  ${catteryNs} = {
    # use hashedPasswordFile
    user.useSecretPasswordFile = true;

    room.desktop.general.enable = true;
    desktop.hyprland.theme = {
      charm-cat.enable = true;
    };

    system = {
      boot.binfmt.enable = true;
      fileSystems.samba = {
        enable = true;
        inherit client;
      };
    };
    services = {
      wg-quick.configNames = inputs.hosts-secrets.lib.settings.wireguard.configNames.${host} or [ ];
      openssh.settings = {
        StreamLocalBindUnlink = true;
      };
    };
  };

  security.sudo.extraConfig = ''
    Defaults env_reset, timestamp_timeout=60
  '';

}
