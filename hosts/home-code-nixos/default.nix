inputs@{
  nixpkgs,
  vscode-server,
  home-manager,
  ...
}:
let
  host = {
    username = "meow";
    lib = import ../../lib;
  };
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

      users.users.${host.username} = {
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
        users.${host.username}.imports = [ ./home.nix ];
      };
    };
in
nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit host;
    inherit inputs;
  };
  modules = [
    home-manager.nixosModules.home-manager
    vscode-server.nixosModules.default
    configuration
  ];
}
