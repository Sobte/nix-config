{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.video;
in
{
  options.${namespace}.apps.video = {
    enable = lib.mkEnableOption "video";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      syncplay # syncs media playback
      vlc # media player
    ];

    # player for things that vlc can't
    programs = {
      # player for things that vlc can't
      mpv.enable = true;

      # recording tool (lol)
      obs-studio.enable = true;
    };
  };

}
