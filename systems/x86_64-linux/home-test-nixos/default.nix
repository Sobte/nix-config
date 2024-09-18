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
    room.desktop.general.enable = true;
    desktop.hyprland.theme = {
      charm-cat.enable = true;
    };

    system.fileSystems.samba = {
      enable = true;
      inherit client;
    };
    shared.services.wg-quick = {
      enable = true;
      configNames = [ "wg-come-home" ];
    };
  };

  system.stateVersion = "24.05";
}
