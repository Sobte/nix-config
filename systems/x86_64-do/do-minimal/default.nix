{
  cattery = {
    user.name = "root"; # use nixos as default user
    room.server.enable = true;
    system.boot.efi.enable = false;
  };

  system.stateVersion = "24.11";
}
