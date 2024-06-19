{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # cli stuff
      kwalletcli
    ];
  };
}
