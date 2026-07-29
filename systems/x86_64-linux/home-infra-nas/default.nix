{
  imports = [
    ./hardware.nix
    ./services.nix
    # ./disk.nix
  ];

  cattery = {
    room.server.nas = {
      enable = true;
      zfs.enable = true;
      beszel.hub.enable = false;
    };
    system = {
      boot = {
        efi.enable = true;
        kernel.version = "6.18";
      };
      impermanence = {
        enable = true;
      };
    };
  };

  # pve zfs
  networking.hostId = "6b72ef25"; # head -c 8 /etc/machine-id

  boot.zfs.extraPools = [
    "fast"
    "tank"
  ];

  system.stateVersion = "26.11";
}
