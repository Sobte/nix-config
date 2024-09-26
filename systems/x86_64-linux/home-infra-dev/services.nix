{ namespace, ... }:
{
  ${namespace} = {
    services = {
      # Do not add ensureDatabases yet because gitea will add it.
      postgresql.enable = true;
      gitea = {
        enable = true;
        dbBackend = "postgresql";
        useWizard = true;
      };
    };
    shared.services.wg-quick.configNames = [ "wg-come-home" ];
  };

  # ports
  networking.firewall =
    let
      ports = [
        80
        443
        3000
        45235
      ];
    in
    {
      allowedTCPPorts = ports;
      allowedUDPPorts = ports;
    };
}
