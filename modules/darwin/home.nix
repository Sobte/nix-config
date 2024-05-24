{pkgs,...}: {
  imports = [
    ../shared/home.nix
  ];

  home = {
    packages = with pkgs; [
      android-tools
      iina # video player, tho i usually use vlc
      powershell
    ];
  };

  programs = {
    zsh.initExtra = ''
      # pnpm
      export PNPM_HOME="/Users/meow/Library/pnpm"
      # check pnpm home exists in path
      if [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
          export PATH="$PATH:$PNPM_HOME"
      fi
      # brew
      export BREW_HOME="/opt/homebrew"
      # check brew home exists in path
      if [[ ":$PATH:" != *":$BREW_HOME/bin:"* ]]; then
          export PATH="$PATH:$BREW_HOME/bin"
      fi
    '';

    vscode.enable = true;
  };
}
