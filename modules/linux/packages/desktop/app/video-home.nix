{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      syncplay # syncs media playback
      vlc # media player
    ];
  };

  # player for things that vlc can't
  programs = {
    # player for things that vlc can't
    mpv.enable = true;

    # recording tool (lol)
    obs-studio.enable = true;
  };
}
