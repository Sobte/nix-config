{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # network
      cloudflared # tunnel
      cloudflare-warp
      tailscale
    ];
  };
}
