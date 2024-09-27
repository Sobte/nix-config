{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.brew;
in
{
  options.${namespace}.brew = {
    enable = lib.mkEnableOption "brew";
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
      };
      brews = [ ];
      # software that can't update itself.
      # giving the ablitity to self update is usually more efficient,
      # tho some software is not able to do so.
      casks = [
        "google-chrome"
        "jetbrains-toolbox"
        "thunderbird" # email client
        "microsoft-remote-desktop" # remote desktop client
        "signal" # instant messaging application focusing on security
        "obsidian" # obsidian
      ];
    };

    ${namespace}.home.extraOptions = {
      programs = {
        zsh.initExtra = lib.mkAfter ''
          # brew
          export BREW_HOME="/opt/homebrew"
          # check brew home exists in path
          if [[ ":$PATH:" != *":$BREW_HOME/bin:"* ]]; then
              export PATH="$PATH:$BREW_HOME/bin"
          fi
        '';
      };
    };
  };
}
