{ inputs, catteryNs, ... }:
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
      wg-quick.configNames = [ "wg-come-home" ];
    };
  };

  networking.firewall =
    let
      ports = [
        80
        443
        53
      ];
    in
    {
      allowedTCPPorts = ports;
      allowedUDPPorts = ports;
    };
}
