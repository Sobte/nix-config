{
  inputs,
  host,
  namespace,
  catteryNs,
  ...
}:
let
  domain = inputs.hosts-secrets.lib.settings.domains.dns;
in
{
  ${catteryNs} = {
    services = {
      adguardhome = {
        enable = true;
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

  ${namespace}.firewall.ports = [
    80
    443
    53
  ];
}
