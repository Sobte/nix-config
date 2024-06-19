{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # cli stuff
      p7zip
    ];
  };
}
