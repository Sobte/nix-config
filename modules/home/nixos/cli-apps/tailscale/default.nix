{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.cli-apps.tailscale;
in
{
  options.${namespace}.cli-apps.tailscale = {
    enable = lib.mkEnableOption "tailscale";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      # network
      tailscale
    ];
  };

}
