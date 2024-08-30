{ config, namespace, ... }:
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
  };

  # wg-quick configuration
  networking.wg-quick.interfaces = {
    wg-come-home = {
      # TODO use hosts-secrets (garnix no cache secrets)
      configFile = "${
        config.users.users.${config.${namespace}.user.name}.home
      }/.config/hosts-secrets/hosts/home-test-nixos/wg-come-home.conf";
    };
  };

  system.stateVersion = "24.05";
}
