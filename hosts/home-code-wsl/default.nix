inputs@{
  nixpkgs,
  nixos-wsl,
  home-manager,
  vscode-server,
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

      # wsl configuration
      wsl = {
        enable = true;
        defaultUser = "${host.username}";
        nativeSystemd = true;
        useWindowsDriver = true;
        # docker-desktop.enable = true;
      };

      networking.hostName = "home-code-wsl"; # tower pc built in 2020, get it?

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
    nixos-wsl.nixosModules.default
    configuration
  ];
}
