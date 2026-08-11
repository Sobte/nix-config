let
  main-device = "/dev/nvme0n1";
in
{
  disko.devices = {
    disk = {
      main = {
        device = main-device;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "noatime"
                  "fmask=0137"
                  "dmask=0027"
                  "errors=remount-ro"
                ];
              };
            };

            # lvm
            pve = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "pve";
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      pve = {
        type = "lvm_vg";
        lvs = {
          # System root partition: Btrfs with subvolumes
          root = {
            size = "100G";
            priority = 100;
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ]; # force format
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd:1" ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd:1"
                    "noatime"
                  ];
                };
                # Adding @var/log to prevent logs from bloating snapshots
                "@log" = {
                  mountpoint = "/var/log";
                  mountOptions = [
                    "compress=zstd:1"
                    "noatime"
                  ];
                };
              };
            };
          };

          # Swap
          swap = {
            size = "8G";
            priority = 200;
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true;
            };
          };

          # LVM-Thin Pool: this is local-lvm in PVE, no filesystem mount
          data = {
            size = "100%FREE";
            priority = 900;
            lvm_type = "thin-pool";
          };
        };
      };
    };
  };
}
