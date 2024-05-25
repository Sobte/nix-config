{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/linux/core/services/samba.nix
    ../../modules/linux/desktop/configuration.nix
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  ];

  # wg-quick configuration
  networking.wg-quick.interfaces = {
    wg-go-home = {
      configFile = "${config.users.users.meow.home}/.config/hosts-secrets/hosts/home-code-nixos/wg-go-home.conf";
    };
  };

}
