# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2f1dc58e-6d8a-4cb4-8247-b4e9acf39681";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=lzo"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/2f1dc58e-6d8a-4cb4-8247-b4e9acf39681";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=lzo"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/52F7-2610";
    fsType = "vfat";
    options = [
      "noatime"
      "fmask=0137"
      "dmask=0027"
      "errors=remount-ro"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2f1dc58e-6d8a-4cb4-8247-b4e9acf39681";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=lzo"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/72a6713a-4762-4db8-8149-8f32ebc9317c"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0f0np0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0f1np1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp8s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
