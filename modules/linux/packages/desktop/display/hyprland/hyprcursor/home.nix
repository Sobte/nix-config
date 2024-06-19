{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprcursor # cursor theme
  ];
}
