inputs@{ nix-darwin, home-manager, ... }:
let
  host = {
    username = "meow";
    lib = import ../../lib;
  };
  configuration =
    { ... }:
    {
      imports = [ ./configuration.nix ];

      # used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      nixpkgs.hostPlatform = "aarch64-darwin";

      home-manager = {
        extraSpecialArgs = {
          inherit inputs;
        };
        users.${host.username}.imports = [ ./home.nix ];
      };

      users.users.${host.username}.home = "/Users/${host.username}";
    };
in
nix-darwin.lib.darwinSystem {
  specialArgs = {
    inherit host;
    inherit inputs;
  };
  modules = [
    home-manager.darwinModules.home-manager
    configuration
  ];
}
