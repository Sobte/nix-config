{ config, host, ... }:
{
  imports = [
    ../../modules/linux/general-desktop.nix

    # desktop, use the charm-cat theme auto load hyprland
    ../../modules/linux/packages/desktop/display/hyprland/theme/charm-cat
    # vmware
    ../../modules/linux/packages/desktop/services/vmware.nix

    ../../modules/shared/all.nix
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
      }/.config/hosts-secrets/hosts/home-test-nixos/wg-come-home.conf";
    };
  };
}
