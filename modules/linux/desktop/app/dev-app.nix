{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      ## jetbrains ide
      jetbrains-toolbox
      jetbrains.webstorm
      jetbrains.rust-rover
      jetbrains.ruby-mine
      jetbrains.rider
      jetbrains.pycharm-professional
      jetbrains.phpstorm
      jetbrains.idea-ultimate
      jetbrains.goland
      jetbrains.dataspell
      jetbrains.datagrip
      jetbrains.clion

      ## android studio
      android-studio
    ];
  };
}
