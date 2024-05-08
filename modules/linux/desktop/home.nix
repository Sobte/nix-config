{pkgs, ...}: {
  imports = [
    ../core/home.nix
  ];

  home = {
    packages = with pkgs; [
      # network
      cloudflared # tunnel
      cloudflare-warp
      tailscale

      # apps
      bitwarden-desktop
      telegram-desktop
      discord
      filezilla
      geogebra6
      gimp
      inkscape-with-extensions
      gparted
      heroic
      obsidian
      qbittorrent
      r2modman
      syncplay
      ventoy-full
      vlc
      kdePackages.kleopatra
      libreoffice
      fluffychat
    ];
  };

  # the linux browser (TM)
  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox-devedition-bin;
    };

    # chromium for google
    chromium = {
      enable = true;
      package = pkgs.google-chrome;
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
      ];
    };

    # browserpass for password management
    browserpass = {
      enable = true;
      browsers = [
        "chrome"
      ];
    };

    # i'd rather like to configure in vscode and use config sync,
    # since changes are mostly gui based
    vscode.enable = true;

    # player for things that vlc can't
    mpv.enable = true;

    # recording tool (lol)
    obs-studio.enable = true;
  };
}
