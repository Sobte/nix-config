{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;

  cfg = config.${namespace}.cli-apps.android;
in
{
  options.${namespace}.cli-apps.android = {
    enable = lib.mkEnableOption "android";
  };

  config = lib.mkIf (cfg.enable && isDarwin) { home.packages = with pkgs; [ android-tools ]; };

}
