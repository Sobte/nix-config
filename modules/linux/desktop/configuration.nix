{ pkgs, inputs, ... }:
{
  imports = [ ../core/configuration.nix ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ ];

  # As of NixOS 22.05 ("Quokka"), you can enable Ozone Wayland support in
  # Chromium and Electron based applications by setting
  # the environment variable NIXOS_OZONE_WL=1. For example, in a configuration.nix:
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # hyprland and wayland
  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
  };

  # sddm for login
  services.displayManager.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # plasma6
  services.desktopManager.plasma6.enable = true;

  # use CUPS for printing
  services.printing.enable = true;

  # enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.pipewire.enable = true;

  # the way to mount disks
  services.udisks2.enable = true;

  # the app that maximizes my retention
  # programs.steam.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # fcitx5 with qt6
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-rime
        kdePackages.fcitx5-configtool
      ];
    };
  };
}
