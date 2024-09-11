{
  namespace,
  ...
}:
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    room.desktop.general.enable = true;
    desktop.hyprland.theme = {
      charm-cat.enable = true;
    };

    system.fileSystems = {
      home-nas.enable = true;
    };
    services.wg-quick = {
      enable = true;
      configNames = [ "wg-come-home" ];
    };
  };

  system.stateVersion = "24.05";
}
