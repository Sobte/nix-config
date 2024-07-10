{ host, ... }:
{
  imports = [
    ./desktop.nix

    # efi boot
    ./packages/core/boot/loader/efi.nix
    # core services
    ./packages/core/services/docker.nix
    ./packages/core/services/udisks2.nix
    ./packages/core/services/wireless.nix
  ];

  home-manager = {
    users.${host.username}.imports = [
      # core app
      ./packages/core/app/disk-home.nix
      # desktop app
      ./packages/desktop/app/browser-home.nix
      ./packages/desktop/app/video-home.nix
      ./packages/desktop/app/vscode-home.nix
    ];
  };

  # disable sudo password
  security.sudo.wheelNeedsPassword = false;
}
