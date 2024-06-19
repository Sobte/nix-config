{ pkgs, ... }:
{
  imports = [ ../shared/dev.nix ];

  home = {
    packages = with pkgs; [
      android-tools
      iina # video player, tho i usually use vlc
      powershell
    ];
  };

  programs = {
    zsh.initExtra = ''
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
