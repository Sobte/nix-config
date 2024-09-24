{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.cli-apps.cloudflared;
in
{
  options.${namespace}.cli-apps.cloudflared = {
    enable = lib.mkEnableOption "cloudflared";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      # network
      cloudflared # tunnel
    ];
  };

}
