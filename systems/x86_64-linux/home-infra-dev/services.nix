{ namespace, ... }:
# let
#   domain = "git.sobte.dev";
# in
{
  ${namespace} = {
    services = {
      # Do not add ensureDatabases yet because gitea will add it.
      postgresql.enable = true;
      # acme = {
      #   useRoot = true;
      #   certs.${domain} = { };
      # };
      # nginx = {
      #   enable = true;
      #   secrets.configNames = [ "${domain}" ];
      # };
      gitea = {
        enable = true;
        dbBackend = "postgresql";
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
