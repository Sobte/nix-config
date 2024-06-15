{ ... }:
{
  imports = [
    ../../modules/linux/desktop/home.nix
    ../../modules/linux/desktop/app/browser-home.nix
    ../../modules/linux/desktop/app/remote-home.nix
    ../../modules/linux/desktop/app/safety-home.nix
    ../../modules/linux/desktop/services/flatpak/home.nix
    ../../modules/linux/desktop/app/vscode-home.nix

    # desktop, use the charm-cat theme auto load hyprland
    ../../modules/linux/desktop/display/hyprland/theme/charm-cat/home.nix
  ];
}
