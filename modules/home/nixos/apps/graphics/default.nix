{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.graphics;
in
{
  options.${namespace}.apps.graphics = {
    enable = lib.mkEnableOption "graphics";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      gimp
      inkscape-with-extensions
    ];
  };

}
