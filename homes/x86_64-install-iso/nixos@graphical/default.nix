{
  home.stateVersion = "24.11";

  cattery = {
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
