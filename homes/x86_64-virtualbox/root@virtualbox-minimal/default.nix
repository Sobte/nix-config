{
  home.stateVersion = "25.11";

  cattery = {
    room.server.enable = true;
    # convenient to check specifications during first installation
    cli-apps.tool = {
      fastfetch.enable = true;
      speedtest.enable = true;
    };
  };

}
