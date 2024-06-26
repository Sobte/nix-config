{ host, ... }:
{
  imports = [
    ./desktop.nix

    # core services
    ./packages/core/services/udisks2.nix
  ];

  home-manager = {
    users.${host.username}.imports = [
      # core app
      ./packages/core/app/disk-home.nix
      # desktop app
      ./packages/desktop/app/browser-home.nix
      ./packages/desktop/app/vscode-home.nix
    ];
  };

  # disable sudo password
  security.sudo.wheelNeedsPassword = false;
}
