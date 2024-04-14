{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../shared/configuration.nix
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  ];

  # As of NixOS 22.05 ("Quokka"), you can enable Ozone Wayland support in 
  # Chromium and Electron based applications by setting 
  # the environment variable NIXOS_OZONE_WL=1. For example, in a configuration.nix:
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  networking.wireless.iwd.enable = true;  # Enables wireless support.
  networking.networkmanager = {
    enable = true;  # Easiest to use and most distros use this by default.
    wifi.backend = "iwd";
  };

  security.sudo.wheelNeedsPassword = false; # disable sudo password

  nix = {
    gc = {
      automatic = true;
      persistent = true;
      dates = "0/4:0"; # expands to "*-*-* 00/04:00:00"
      randomizedDelaySec = "45min";
      options = "--delete-older-than 30d";
    };
  };

  users.defaultUserShell = pkgs.zsh;

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

  # SUID wrapper, not sure if i need this, but just to not bother my future self
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # the way to mount disks
  services.udisks2.enable = true;

  # the app that maximizes my retention
  programs.steam.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # the program that i have to use to do any work
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  # fcitx5 with qt6
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      kdePackages.fcitx5-configtool
    ];
  };

}
