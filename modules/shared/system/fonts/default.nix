{ pkgs, catteryNs, ... }:
{
  ${catteryNs}.system.fonts.extraPackages = with pkgs; [
    edusong
  ];
}
