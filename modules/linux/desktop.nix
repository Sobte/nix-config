{ host, ... }:
{
  imports = [
    ./base.nix

    # core services
    ./packages/core/services/udisks2.nix
    ./packages/core/services/wireless.nix
    # desktop services
    ./packages/desktop/services/fcitx5
    ./packages/desktop/services/peripherals
    ./packages/desktop/services/xdg
  ];

  home-manager = {
    users.${host.username}.imports = [
      # core app
      ./packages/core/app/disk-home.nix
      # desktop app
      ./packages/desktop/app/useful-app/home.nix
      ./packages/desktop/app/graphics-home.nix
      # desktop services
      ./packages/desktop/services/fcitx5/home.nix
      ./packages/desktop/services/xdg/home.nix
    ];
  };

  # disable sudo password
  security.sudo.wheelNeedsPassword = false;
}
