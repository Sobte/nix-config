{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.network;
in
{
  options.${namespace}.apps.network = {
    enable = lib.mkEnableOption "network";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      # network
      cloudflared # tunnel
      cloudflare-warp
      tailscale
    ];
  };

}
