{ namespace, ... }:
let
  domain = "home.pwd.oop.icu";
in
{
  ${namespace} = {
    services = {
      vscode-server.enable = true;
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
        secrets.configNames = [ "${domain}" ];
      };
    };
  };

  # ports
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
