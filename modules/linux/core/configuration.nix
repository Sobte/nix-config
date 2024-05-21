{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../shared/configuration.nix
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  ];

  networking = {
    wireless.iwd.enable = true; # Enables wireless support.
    networkmanager = {
      enable = true; # Easiest to use and most distros use this by default.
      wifi.backend = "iwd";
    };
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

  # SUID wrapper, not sure if i need this, but just to not bother my future self
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # the way to mount disks
  services.udisks2.enable = true;

  # the program that i have to use to do any work
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };
}
