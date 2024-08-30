{ config, namespace, ... }:
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    room.server.enable = true;

    services.vscode-server.enable = true;
  };

  # openssh port
  services.openssh.ports = [ 6422 ];

  # wg-quick configuration
  networking.wg-quick.interfaces = {
    wg-come-home = {
      # TODO use hosts-secrets (garnix no cache secrets)
      configFile = "${
        config.users.users.${config.${namespace}.user.name}.home
      }/.config/hosts-secrets/hosts/home-dev-server/wg-come-home.conf";
    };
  };

  system.stateVersion = "24.05";

}
