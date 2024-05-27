{ pkgs, ... }:
{
  imports = [ ../../shared/home.nix ];

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
    zsh.initExtra = ''
      # pnpm
      export PNPM_HOME="$HOME/.local/share/pnpm"
      # check pnpm home exists in path
      if [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
          export PATH="$PATH:$PNPM_HOME"
      fi
    '';

    git.extraConfig = {
      credential.helper = "/etc/profiles/per-user/$(whoami)/bin/git-credential-libsecret";
    };
  };
}
