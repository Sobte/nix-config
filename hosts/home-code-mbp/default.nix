inputs @ {
  nix-darwin,
  home-manager,
  ...
}: let
  configuration = {...}: {
    imports = [
      ./configuration.nix
    ];

    # used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;

    nixpkgs.hostPlatform = "aarch64-darwin";

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

    users.users.meow.home = "/Users/meow";
  };
in
  nix-darwin.lib.darwinSystem {
    specialArgs = {
      inherit inputs;
    };
    modules = [
      home-manager.darwinModules.home-manager
      configuration
    ];
  }