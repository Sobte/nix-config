{
  cattery = {
    room.desktop.dev.enable = true;
    services = {
      wg-quick = {
        enable = true;
        configNames = [ "wg-go-home" ];
      };
      sing-box = {
        enable = true;
        # secrets.owner = "meow";
      };
    };
  };

  system.stateVersion = 5;
}
