{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # c
    autoconf
    automake
    cmake
    gcc
  ];
}
