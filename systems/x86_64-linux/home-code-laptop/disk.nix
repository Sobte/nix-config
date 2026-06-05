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
              size = "1G";
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

            swap = {
              size = "100G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };

            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";

                settings.allowDiscards = true;
                enrollFido2 = true;
                # Do not wait for recovery displaying and blocking formatting.
                enrollRecovery = false;

                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # force format
                  subvolumes = {
                    "@persistent" = {
                      mountpoint = "/persistent";
                      mountOptions = [ "compress=zstd:1" ];
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
  };

  fileSystems."/home" = {
    # focus
    neededForBoot = true;
  };

  fileSystems."/persistent" = {
    # focus
    neededForBoot = true;
  };
}
