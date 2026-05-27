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
      wg-quick.configNames = [ "wg-come-home" ];
      openssh.settings = {
        StreamLocalBindUnlink = true;
      };
    };
  };

  system.stateVersion = "26.05";
}
