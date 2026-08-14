{
  config,
  inputs,
  host,
  namespace,
  catteryNs,
  ...
}:
let
  domain = inputs.hosts-secrets.lib.settings.domains.web;
in
{
  ${catteryNs} = {
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
      beszel = {
        enable = true;
        hub.enable = true;
        agent.enable = false;
      };
      wg-quick.configNames = inputs.hosts-secrets.lib.settings.wireguard.configNames.${host} or [ ];
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
        config.${catteryNs}.secrets.hosts.global.files."www/singbox/mac.json".path
      }" /var/www/html/singbox/mac.json

      chown -R nginx:nginx /var/www/
    '';
  };

  # ports
  ${namespace}.firewall.ports = [
    80
    443
  ];
}
