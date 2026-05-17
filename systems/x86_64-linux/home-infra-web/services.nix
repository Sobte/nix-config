let
  domain = "home.web.oop.icu";
in
{
  cattery = {
    services = {
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
      ];
    in
    {
      allowedTCPPorts = ports;
      allowedUDPPorts = ports;
    };
}
