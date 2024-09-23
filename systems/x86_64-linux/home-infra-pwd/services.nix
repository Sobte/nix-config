{ namespace, ... }:
let
  domain = "home.pwd.oop.icu";
in
{
  ${namespace} = {
    services = {
      vscode-server.enable = true;
      acme = {
        useRoot = true;
        certs.${domain} = { };
      };
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
      nginx = {
        enable = true;
        virtualHosts.${domain} = {
          addSSL = true;
          useACMEHost = domain;
          quic = true;
          locations."/".proxyPass = "http://localhost:8000";
        };
      };
    };
  };

  # ports
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
