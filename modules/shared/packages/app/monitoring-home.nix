{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # tui
    btop
    htop
    glances
    inxi # yep i have 4 monitoring tools for some reason
  ];
}
