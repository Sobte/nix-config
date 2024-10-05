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
    services.wg-quick.configNames = [ "wg-come-home" ];
  };

  system.stateVersion = "24.11";
}
