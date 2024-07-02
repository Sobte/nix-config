{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      ## jetbrains ide
      jetbrains-toolbox
      ## android studio
      android-studio
    ];
  };
}
