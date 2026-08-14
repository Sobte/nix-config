{ catteryNs, ... }:
{
  imports = [ ./hardware.nix ];

  ${catteryNs} = {
    room.desktop.wsl.enable = true;

    services.vscode-server.enable = true;
    # disable hardware peripherals
    system = {
      peripherals.enable = false;
      boot.binfmt.enable = true;
    };
  };

}
