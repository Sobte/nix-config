{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.science;
in
{
  options.${namespace}.apps.science = {
    enable = lib.mkEnableOption "science";
  };

  config = lib.mkIf (cfg.enable && isLinux) { home.packages = with pkgs; [ geogebra6 ]; };

}
