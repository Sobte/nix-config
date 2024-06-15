{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprshot # screenshot
    wl-clipboard # for hyprshot
    grim # for hyprshot
    slurp # for hyprshot
  ];

  # examples: -m output -o ~/Pictures/Screenshots -- nomacs
}
