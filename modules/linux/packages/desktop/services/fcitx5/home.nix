{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # cli stuff
      rime-cli
    ];
  };
}
