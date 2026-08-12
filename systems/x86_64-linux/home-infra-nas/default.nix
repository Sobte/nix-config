{ catteryNs, namespace, ... }:
{
  imports = [
    ./hardware.nix
    ./services.nix
    # ./disk.nix
  ];

  # Machine-name → IP mappings from hosts-secrets settings.
  ${namespace}.hosts.enable = true;

  ${catteryNs} = {
    nix.secrets.enable = true;
    room.server.nas = {
      enable = true;
      zfs.enable = true;
      beszel.hub.enable = false;
    };
    system = {
      boot = {
        efi.enable = true;
        kernel = {
          useLatestZfsCompatible = true;
        };
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
