{
  imports = [ ./system.nix ];

  cattery = {
    nix.secrets.enable = true;
    room.desktop.dev.enable = true;
    services = {
      wg-quick = {
        enable = true;
        configNames = [ "wg-go-home" ];
      };
    };
  };

  system.stateVersion = 5;
}
