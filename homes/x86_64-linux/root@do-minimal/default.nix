{ catteryNs, ... }:
{
  home.stateVersion = "26.11";

  ${catteryNs} = {
    room.server.enable = true;
    # convenient to check specifications during first installation
    cli-apps.tool = {
      fastfetch.enable = true;
      speedtest.enable = true;
    };
  };

}
