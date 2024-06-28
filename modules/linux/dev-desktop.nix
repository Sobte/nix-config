{ host, ... }:
{
  imports = [
    ./desktop.nix

    ../shared/dev.nix
    # efi boot
    ./packages/core/boot/loader/efi.nix
    # core services
    ./packages/core/services/docker.nix
    ./packages/core/services/vscode-server.nix
    # desktop services
    ./packages/desktop/services/flatpak
  ];

  home-manager = {
    users.${host.username}.imports = [
      # core app
      ./packages/core/app/ollama-home.nix
      # desktop app
      ./packages/desktop/app/browser-home.nix
      ./packages/desktop/app/instant-messengers-home.nix
      ./packages/desktop/app/jetbrains-home.nix
      ./packages/desktop/app/mail-home.nix
      ./packages/desktop/app/network-home.nix
      ./packages/desktop/app/remote-home.nix
      ./packages/desktop/app/safety-home.nix
      ./packages/desktop/app/science-home.nix
      ./packages/desktop/app/terminal-home.nix
      ./packages/desktop/app/video-home.nix
      ./packages/desktop/app/vscode-home.nix
      # desktop services
      ./packages/desktop/services/flatpak/home.nix
    ];
  };

  # disable sudo password
  security.sudo.wheelNeedsPassword = false;
}
