{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.safety;
in
{
  options.${namespace}.apps.safety = {
    enable = lib.mkEnableOption "safety";
  };

  config = lib.mkIf (cfg.enable && isLinux) { home.packages = with pkgs; [ bitwarden-desktop ]; };

}
