{
  imports = [
    ./hardware.nix
    ./services.nix
  ];

  cattery = {
    user.name = "root"; # use root as default user
    room.server.enable = true;
    services.getty.enable = true;
    system.boot.efi.enable = true;
  };

  system.stateVersion = "26.11";
}
