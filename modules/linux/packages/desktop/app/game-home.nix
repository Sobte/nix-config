{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      heroic
      r2modman
    ];
  };
}
