{ catteryNs, ... }:
{
  home.stateVersion = "26.11";

  ${catteryNs} = {
    room.desktop.general.enable = true;
    apps.browser = {
      needs = [
        "firefox"
        "chromium"
      ];
    };
    # convenient to check specifications during first installation
    cli-apps.tool = {
      fastfetch.enable = true;
      speedtest.enable = true;
    };

    apps.vscode.commandLineArgs = [
      "--disable-gpu"
    ];
  };
}
