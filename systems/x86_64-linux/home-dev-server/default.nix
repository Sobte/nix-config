{
  namespace,
  ...
}:
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    room.server.enable = true;

    services = {
      vscode-server.enable = true;
      wg-quick = {
        enable = true;
        configNames = [ "wg-come-home" ];
      };
    };
  };

  # openssh port
  services.openssh.ports = [ 6422 ];

  system.stateVersion = "24.05";
}
