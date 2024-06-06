{ config, ... }:
{
  imports = [
    ../../modules/linux/core/services/samba.nix
    ../../modules/linux/desktop/configuration.nix
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];

  services.vscode-server.enable = true;

  # wg-quick configuration
  networking.wg-quick.interfaces = {
    wg-come-home = {
      # TODO use hosts-secrets (garnix no cache secrets)
      configFile = "${config.users.users.meow.home}/.config/hosts-secrets/hosts/home-test-nixos/wg-come-home.conf";
    };
  };
}