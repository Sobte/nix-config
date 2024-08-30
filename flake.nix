{
  inputs = {
    flake-schemas.url = "github:DeterminateSystems/flake-schemas";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        # snowfall doc: https://snowfall.org/guides/lib/quickstart/
        inherit inputs;
        # root dir
        src = ./.;

        snowfall = {
          namespace = "cattery";
          meta = {
            name = "meow-flake";
            title = "Meow' Nix Flakes";
          };
        };
      };

      shared-modules = builtins.attrValues (
        lib.snowfall.module.create-modules { src = ./modules/shared; }
      );

      nixos-modules = with inputs; [
        home-manager.nixosModules.home-manager
        lanzaboote.nixosModules.lanzaboote
        sops-nix.nixosModules.sops
        vscode-server.nixosModules.default
        nixos-wsl.nixosModules.default
      ];

    in
    lib.mkFlake {

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [ ];
      };

      systems = {
        modules = {
          nixos = shared-modules ++ nixos-modules;
          darwin = shared-modules;
          install-iso = shared-modules;
          sd-aarch64 = shared-modules;
        };
      };

      homes.modules = with inputs; [ nix-index-database.hmModules.nix-index ];

      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };

    };
}
