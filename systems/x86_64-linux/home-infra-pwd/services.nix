let
  domain = "home.pwd.oop.icu";
in
{
  cattery = {
    services = {
      postgresql = {
        enable = true;
        extraOptions = {
          ensureDatabases = [ "vaultwarden" ];
          ensureUsers = [
            {
              name = "vaultwarden";
              ensureDBOwnership = true;
            }
          ];
        };
      };
      vaultwarden = {
        enable = true;
        dbBackend = "postgresql";
      };
      acme = {
        useRoot = true;
        certs.${domain} = { };
      };
      nginx = {
        enable = true;
        secrets.configNames = [ "${domain}.conf" ];
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
        47315
      ];
    in
    {
      allowedTCPPorts = ports;
      allowedUDPPorts = ports;
    };
}
