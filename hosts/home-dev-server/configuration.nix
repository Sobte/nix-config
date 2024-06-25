{ config, host, ... }:
{
  imports = [
    ../../modules/linux/server.nix
    # home samba
    ../../modules/linux/packages/core/services/samba.nix
    # vscode server
    ../../modules/linux/packages/core/services/vscode-server.nix
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];

  # openssh port
  services.openssh.ports = [ 6422 ];

  # wg-quick configuration
  networking.wg-quick.interfaces = {
    wg-come-home = {
      # TODO use hosts-secrets (garnix no cache secrets)
      configFile = "${
        config.users.users.${host.username}.home
      }/.config/hosts-secrets/hosts/home-dev-server/wg-come-home.conf";
    };
  };
}
