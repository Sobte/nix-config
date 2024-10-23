{
  cattery = {
    services = {
      # Do not add ensureDatabases yet because gitea will add it.
      postgresql.enable = true;
      forgejo = {
        enable = true;
        dbBackend = "postgresql";
        useWizard = true;
      };
      cloudflared = {
        enable = true;
        tunnels = {
          "466fcedf-48d6-4066-89e4-069b29d27cd8" = {
            default = "http_status:404";
            ingress = {
              "git.sobte.dev" = "http://localhost:3000";
            };
          };
        };
      };
      wg-quick.configNames = [ "wg-come-home" ];
    };
  };

  # ports
  networking.firewall =
    let
      ports = [
        80
        443
        45235
      ];
    in
    {
      allowedTCPPorts = ports;
      allowedUDPPorts = ports;
    };
}
