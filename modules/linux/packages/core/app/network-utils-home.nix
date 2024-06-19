{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # network
      inetutils # telnet / ping
    ];
  };
}
