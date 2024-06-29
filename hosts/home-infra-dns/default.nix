inputs@{
  nixpkgs,
  vscode-server,
  home-manager,
  ...
}:
let
  host = {
    username = "root";
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

      networking.hostName = "home-infra-dns";

      time.timeZone = "Asia/Shanghai";
      i18n.defaultLocale = "en_US.UTF-8";

      home-manager = {
        extraSpecialArgs = {
          inherit host;
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
    configuration
  ];
}
