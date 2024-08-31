{ namespace, ... }:
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    room.desktop.wsl.enable = true;

    services.vscode-server.enable = true;
  };

  system.stateVersion = "24.05";
}
