inputs @ {
  nixpkgs,
  nixos-wsl,
  home-manager,
  ...
}: let
  configuration = {...}: {
    imports = [
      # include NixOS-WSL modules
      # <nixos-wsl/modules>
      ../../modules/linux/configuration.nix
      ../../modules/linux/core/services/samba.nix
      ./hardware-configuration.nix
    ];

    # this doesn't need to be touched,
    # touching it will definitely break things, so beware
    system.stateVersion = "24.05";
    
    # wsl configuration
    wsl.enable = true;
    wsl.defaultUser = "meow";
    wsl.nativeSystemd = true;
    wsl.useWindowsDriver = true;
    # close the docker in nixos, use docker desktop in windows
    virtualisation.docker.enable = nixpkgs.lib.mkForce false;
    # wsl.docker-desktop.enable = true;

    networking.hostName = "home-code-wsl"; # tower pc built in 2020, get it?

    time.timeZone = "Asia/Shanghai";
    i18n.defaultLocale = "en_US.UTF-8";

    # enable openssh
    services.openssh.enable = true;

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
      users.meow.imports = [
        ./home.nix
      ];
    };
  };
in
  nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
    };
    modules = [
      home-manager.nixosModules.home-manager
      nixos-wsl.nixosModules.default
      configuration
    ];
  }
