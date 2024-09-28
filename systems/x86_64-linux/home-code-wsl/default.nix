{ namespace, ... }:
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    room.desktop.wsl.enable = true;

    services.vscode-server.enable = true;
    # disable hardware peripherals
    system = {
      peripherals.enable = false;
      boot.binfmt.enable = true;
    };
  };

  system.stateVersion = "24.11";
}
