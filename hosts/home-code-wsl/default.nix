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
      ./hardware-configuration.nix
    ];

    # this doesn't need to be touched,
    # touching it will definitely break things, so beware
    system.stateVersion = "24.05";
    
    # wsl configuration
    wsl.enable = true;
    wsl.defaultUser = "meow";
    # wsl.docker-desktop.enable = true;
    wsl.wslConf.network.hostname = "home-code-wsl";

    networking.hostName = "home-code-wsl"; # tower pc built in 2020, get it?

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
