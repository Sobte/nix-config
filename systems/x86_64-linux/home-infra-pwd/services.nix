{
  pkgs,
  inputs,
  host,
  namespace,
  catteryNs,
  ...
}:
let
  domain = inputs.hosts-secrets.lib.settings.domains.pwd;
in
{
  ${catteryNs} = {
    services = {
      postgresql = {
        enable = true;
        package = pkgs.postgresql_19;
        ensureDatabases = [ "vaultwarden" ];
        ensureUsers = [
          {
            name = "vaultwarden";
            ensureDBOwnership = true;
          }
        ];
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
      wg-quick.configNames = inputs.hosts-secrets.lib.settings.wireguard.configNames.${host} or [ ];
    };
  };

  # ports
  ${namespace}.firewall.ports = [
    80
    443
    47315
  ];
}
