{
  imports = [ ./hardware.nix ];

  cattery = {
    room.desktop.wsl.enable = true;

    services.vscode-server.enable = true;
    # disable hardware peripherals
    system = {
      peripherals.enable = false;
      boot.binfmt.enable = true;
    };

    cli-apps.security = {
      gnupg.enable = false;
    };
  };

  system.stateVersion = "24.11";
}
