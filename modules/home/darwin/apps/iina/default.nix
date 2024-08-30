{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;

  cfg = config.${namespace}.apps.iina;
in
{
  options.${namespace}.apps.iina = {
    enable = lib.mkEnableOption "iina";
  };

  config = lib.mkIf (cfg.enable && isDarwin) {
    home.packages = with pkgs; [
      iina # video player, tho i usually use vlc
    ];
  };
}
