{pkgs, ...}: {
  imports = [
    ../../shared/home.nix
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
      usbutils # lsusb

      # disk stuff
      ifuse # for ios
      mtools # NTFS
      nfs-utils # nfs

      # network
      inetutils # telnet / ping
    ];
  };

  programs = {
    git.extraConfig = {
      credential.helper = "/etc/profiles/per-user/$(whoami)/bin/git-credential-libsecret";
    };
  };
}
