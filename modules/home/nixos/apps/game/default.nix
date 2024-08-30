{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.game;
in
{
  options.${namespace}.apps.game = {
    enable = lib.mkEnableOption "game";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      heroic
      r2modman
    ];
  };

}
