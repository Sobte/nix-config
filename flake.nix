{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    darwin = {
      url = "github:nix-darwin/nix-darwin";
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

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cattery-modules = {
      url = "github:nixcafe/cattery-modules/dev";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "darwin";
      inputs.home-manager.follows = "home-manager";
      inputs.snowfall-lib.follows = "snowfall-lib";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    wezterm = {
      url = "github:wez/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    wallpapers = {
      url = "github:Sobte/wallpapers";
      inputs.snowfall-lib.follows = "snowfall-lib";
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
      shared-modules = builtins.attrValues (
        lib.snowfall.module.create-modules { src = ./modules/shared; }
      );
    in
    lib.mkFlake {

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "ventoy-1.1.05" ];
      };

      systems = {
        modules = {
          nixos = nixos-modules ++ shared-modules;
          darwin = darwin-modules ++ shared-modules;
        };
      };

      homes.modules = homes-modules;

      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
    };
}
