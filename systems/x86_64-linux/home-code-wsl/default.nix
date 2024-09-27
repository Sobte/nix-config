{ namespace, ... }:
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    room.desktop.wsl.enable = true;

    services.vscode-server.enable = true;
    # disable hardware peripherals
    system.peripherals.enable = false;
  };

  system.stateVersion = "24.11";
}
