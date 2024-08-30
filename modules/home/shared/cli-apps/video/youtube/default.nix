{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.video.youtube;
in
{
  options.${namespace}.cli-apps.video.youtube = {
    enable = lib.mkEnableOption "youtube";
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ yt-dlp ]; };

}
