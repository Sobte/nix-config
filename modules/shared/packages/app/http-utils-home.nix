{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # cli utils
    wget # fetch thing i don't use
    curl # fetch thing i do use
    aria # no 2 needed
  ];
}
