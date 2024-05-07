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

      ## jetbrains ide
      jetbrains-toolbox
      jetbrains.webstorm
      jetbrains.rust-rover
      jetbrains.ruby-mine
      jetbrains.rider
      jetbrains.pycharm-professional
      jetbrains.phpstorm
      jetbrains.idea-ultimate
      jetbrains.goland
      jetbrains.dataspell
      jetbrains.datagrip
      jetbrains.clion

      ## android studio
      android-studio
    ];
  };

  # the linux browser (TM)
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition-bin;
  };

  # chromium for google
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
    ];
  };

  # browserpass for password management
  programs.browserpass = {
    enable = true;
    browsers = [
      "chrome"
    ];
  };

  # i'd rather like to configure in vscode and use config sync,
  # since changes are mostly gui based
  programs.vscode.enable = true;

  # player for things that vlc can't
  programs.mpv.enable = true;

  # recording tool (lol)
  programs.obs-studio.enable = true;
}
