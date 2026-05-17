{
  imports = [
    ./hardware.nix
    ./services.nix
    # ./disk.nix
  ];

  cattery = {
    user.name = "root"; # use root as default user
    # Enable EFI boot support
    system.boot.efi.enable = true;
    room.server.enable = true;
  };

  system.stateVersion = "26.05";
}
