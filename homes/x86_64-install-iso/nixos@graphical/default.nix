{
  home.stateVersion = "24.11";

  cattery = {
    # convenient to check specifications during first installation
    cli-apps.tool.fastfetch.enable = true;
    room.desktop.general.enable = true;

    apps.vscode.commandLineArgs = [
      "--disable-gpu"
    ];
  };
}
