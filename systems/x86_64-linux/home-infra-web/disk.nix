let
  main-device = "/dev/sda";
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

            root = {
              size = "100%";
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
}
