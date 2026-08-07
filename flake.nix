{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    purr.url = "github:nixcafe/purr";

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cattery-modules = {
      url = "github:nixcafe/cattery-modules";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "darwin";
      inputs.home-manager.follows = "home-manager";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.purr.follows = "purr";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "darwin";
      inputs.home-manager.follows = "home-manager";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wallpapers = {
      url = "github:Sobte/wallpapers";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.purr.follows = "purr";
    };

    nhmeow-cursor = {
      url = "github:nhmeow/nhmeow-cursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.purr.follows = "purr";
    };

    proxmox-nixos = {
      url = "github:SaumonNet/proxmox-nixos";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    hosts-secrets = {
      url = "github:Sobte/hosts-secrets";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.purr.follows = "purr";
    };
  };

  outputs =
    inputs:
    inputs.purr.lib.mkFlake {
      inherit inputs;
      src = ./.;
      namespace = "lovelycat";
      nixpkgsConfig = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "ventoy-1.1.12"
        ];
      };
      extraArgs = {
        catteryNs = "cattery";
      };
      extraModules = with inputs; {
        nixos = [
          cattery-modules.nixosModules.default
          disko.nixosModules.default
          proxmox-nixos.nixosModules.proxmox-ve
        ];
        darwin = [
          cattery-modules.darwinModules.default
        ];
        home = [
          cattery-modules.homeModules.default
        ];
      };
      outputsBuilder = { pkgs, ... }: {
        formatter = pkgs.nixfmt;
      };
      hydraJobs = {
        enable = true;
        as = "builds";
        systems = [ "x86_64-linux" ];
      };
    }
    // {
      colmenaHive = import ./colmena/colmenaHive { inherit inputs; };
    };
}
