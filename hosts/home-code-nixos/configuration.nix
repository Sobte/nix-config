{ config, host, ... }:
{
  imports = [
    ../../modules/linux/dev-desktop.nix

    # kde
    ../../modules/linux/packages/desktop/display/kde
    # home samba
    ../../modules/linux/packages/core/services/samba.nix
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];

  # wg-quick configuration
  networking.wg-quick.interfaces = {
    wg-come-home = {
      # TODO use hosts-secrets (garnix no cache secrets)
      configFile = "${
        config.users.users.${host.username}.home
      }/.config/hosts-secrets/hosts/home-code-nixos/wg-come-home.conf";
    };
  };
}
