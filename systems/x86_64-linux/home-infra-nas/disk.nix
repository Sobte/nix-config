let
  main-device = "/dev/nvme0n1";
in
{
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "relatime"
        "size=30%"
        "mode=755"
      ];
    };

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

            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@persistent" = {
                    mountpoint = "/persistent";
                    mountOptions = [
                      "compress=zstd:1"
                    ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd:1"
                      "noatime"
                    ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd:1"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/persistent" = {
    neededForBoot = true;
  };

  fileSystems."/home" = {
    neededForBoot = true;
  };
}
