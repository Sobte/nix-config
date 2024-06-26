# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    # gpu
    ../../modules/linux/packages/core/boot/gpu/amd.nix
  ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/31e38ff6-5105-4938-92ee-034f861f3a5b";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=lzo"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/31e38ff6-5105-4938-92ee-034f861f3a5b";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=lzo"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/31e38ff6-5105-4938-92ee-034f861f3a5b";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=lzo"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3851-C375";
    fsType = "vfat";
    options = [
      "noatime"
      "fmask=0137"
      "dmask=0027"
      "errors=remount-ro"
    ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens18.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
