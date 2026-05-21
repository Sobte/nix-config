{ config, ... }:
let
  domain = "home.web.oop.icu";
in
{
  cattery = {
    secrets = {
      hosts.global.files = {
        "www/singbox/mac.json" = { };
      };
    };
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

  systemd.services.sync-nginx-www = {
    description = "Sync secret to www directory";

    before = [ "nginx.service" ];
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
    };

    script = ''
      mkdir -p /var/www/html/singbox

      cp -f "${
        config.cattery.secrets.hosts.global.files."www/singbox/mac.json".path
      }" /var/www/html/singbox/mac.json

      chown -R nginx:nginx /var/www/
    '';
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
