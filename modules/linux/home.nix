{pkgs, ...}: {
  imports = [
    ../shared/home.nix
  ];

  home = {
    packages = with pkgs; [
      # common lib
      libsecret # for git credentials

      # cli stuff
      kwalletcli
      ollama # llm
      p7zip
      rime-cli
      gcc
      psmisc # killall

      # disk stuff
      ifuse # for ios
      mtools # NTFS
      nfs-utils # nfs

      # network
      cloudflared # tunnel
      cloudflare-warp
      tailscale
      inetutils # telnet / ping

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

  programs.git.extraConfig = {
    credential.helper = "/etc/profiles/per-user/$(whoami)/bin/git-credential-libsecret";
  };

  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [
  #     fcitx5-rime
  #     kdePackages.fcitx5-configtool
  #   ];
  # };

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
