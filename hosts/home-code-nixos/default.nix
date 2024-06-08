inputs@{
  nixpkgs,
  vscode-server,
  home-manager,
  ...
}:
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

      networking.hostName = "home-code-nixos"; # tower pc built in 2020, get it?

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
    vscode-server.nixosModules.default
    configuration
  ];
}
