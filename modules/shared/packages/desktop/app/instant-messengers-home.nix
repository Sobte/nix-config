{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      telegram-desktop
      vesktop # replace discord
    ];
  };
}
