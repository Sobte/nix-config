inputs@{
  nixpkgs,
  nixos-wsl,
  home-manager,
  vscode-server,
  ...
}:
let
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
        defaultUser = "meow";
        nativeSystemd = true;
        useWindowsDriver = true;
      };
      # close the docker in nixos, use docker desktop in windows
      virtualisation.docker.enable = nixpkgs.lib.mkForce false;
      # wsl.docker-desktop.enable = true;

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
        users.meow.imports = [ ./home.nix ];
      };
    };
in
nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs;
  };
  modules = [
    home-manager.nixosModules.home-manager
    vscode-server.nixosModules.default
    nixos-wsl.nixosModules.default
    configuration
  ];
}
