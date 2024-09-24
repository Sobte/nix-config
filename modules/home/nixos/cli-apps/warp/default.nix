{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.cli-apps.warp;
in
{
  options.${namespace}.cli-apps.warp = {
    enable = lib.mkEnableOption "cloudflare warp";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      # network
      cloudflare-warp
    ];
  };

}
