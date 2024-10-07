{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cattery-modules = {
      url = "github:nixcafe/cattery-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      # TODO: write your own module loader with container support.
      lib = inputs.snowfall-lib.mkLib {
        # snowfall doc: https://snowfall.org/guides/lib/quickstart/
        inherit inputs;
        # root dir
        src = ./.;

        snowfall = {
          namespace = "lovelycat";
          meta = {
            name = "meow-flake";
            title = "Meow' Nix Flakes";
          };
        };
      };

      nixos-modules = with inputs; [
        cattery-modules.nixosModules.default
      ];
      darwin-modules = with inputs; [
        cattery-modules.darwinModules.default
      ];
      homes-modules = with inputs; [
        cattery-modules.homeModules.default
      ];
    in
    lib.mkFlake {

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [ ];
      };

      systems = {
        modules = {
          nixos = nixos-modules;
          darwin = darwin-modules;
        };
      };

      homes.modules = homes-modules;

      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
    };
}
