{
  description = "Meow' Nix Flakes";

  nixConfig = {
    extra-substituters = [ "https://cache.garnix.io" ];
    extra-trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
  };

  inputs = {
    flake-schemas.url = "github:DeterminateSystems/flake-schemas";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-formatter-pack = {
      url = "github:Sobte/nix-formatter-pack/mv-nixfmt_rfc_style";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hosts-secrets = {
      url = "git+ssh://git@github.com/Sobte/hosts-secrets.git";
      flake = false;
    };
  };

  outputs =
    inputs@{
      flake-schemas,
      nixpkgs,
      nix-formatter-pack,
      ...
    }:
    let
      linuxSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      darwinSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forEachSystem = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;

      formatterPackArgs = forEachSystem (system: {
        inherit nixpkgs system;

        checkFiles = [ ./. ];

        config = {
          tools = {
            nixfmt.enable = true;
            deadnix.enable = true;
            statix = {
              enable = true;
              disabledLints = [ "repeated_keys" ];
            };
          };
        };
      });
    in
    {
      inherit (flake-schemas) schemas;

      # nix-formatter-pack
      checks = forEachSystem (system: {
        nix-formatter-pack-check = nix-formatter-pack.lib.mkCheck formatterPackArgs.${system};
      });
      formatter = forEachSystem (system: nix-formatter-pack.lib.mkFormatter formatterPackArgs.${system});

      darwinConfigurations = {
        # $ darwin-rebuild switch --flake ~/.config/nix-config#home-code-mbp
        "home-code-mbp" = import ./hosts/home-code-mbp inputs;
      };

      nixosConfigurations = {
        # $ sudo nixos-rebuild switch --flake ~/.config/nix-config#home-code-nixos
        "home-code-nixos" = import ./hosts/home-code-nixos inputs;
        # $ sudo nixos-rebuild switch --flake ~/.config/nix-config#home-test-nixos
        "home-test-nixos" = import ./hosts/home-test-nixos inputs;
        # $ sudo nixos-rebuild switch --flake ~/.config/nix-config#home-code-wsl
        "home-code-wsl" = import ./hosts/home-code-wsl inputs;
      };

      images = {
        # $ nix build .#images.chinos-r4s21
        # "chinos-r4s21" = nixosConfigurations."chinos-r4s21".config.system.build.sdImage;
      };

      # development shell
      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # nix stuff
              nixfmt-rfc-style
              deadnix
              statix
            ];
          };
        }
      );
    };
}
