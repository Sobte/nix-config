inputs@{ nixpkgs, home-manager, ... }:
let
  configuration =
    { ... }:
    {
      imports = [
        ./hardware-configuration.nix
        ./configuration.nix
      ];

      # this doesn't need to be touched,
      # touching it will definitely break things, so beware
      system.stateVersion = "24.05";

      # use systemd-boot as the bootloader
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      # use amd gpu driver
      boot.initrd.kernelModules = [ "amdgpu" ];

      # fix file system options
      fileSystems = {
        "/".options = [ "compress=lzo" ];
        "/nix".options = [
          "compress=lzo"
          "noatime"
        ];
        "/home".options = [ "compress=lzo" ];
        "/boot".options = [
          "noatime"
          "fmask=0137"
          "dmask=0027"
          "errors=remount-ro"
        ];
      };

      networking.hostName = "home-test-nixos"; # tower pc built in 2020, get it?

      time.timeZone = "Asia/Shanghai";
      i18n.defaultLocale = "en_US.UTF-8";

      users.users.meow = {
        isNormalUser = true;
        extraGroups = [
          "wheel" # for sudo
          "docker"
        ];
      };

      home-manager = {
        extraSpecialArgs = {
          inherit inputs;
        };
        useUserPackages = true;
        useGlobalPkgs = true;
        users.meow.imports = [ ./home.nix ];
      };
    };
in
nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs;
  };
  modules = [
    home-manager.nixosModules.home-manager
    configuration
  ];
}
