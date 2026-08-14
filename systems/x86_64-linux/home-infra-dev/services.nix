{
  pkgs,
  inputs,
  host,
  namespace,
  catteryNs,
  ...
}:
let
  inherit (inputs.hosts-secrets.lib.settings) cloudflared;
in
{
  ${catteryNs} = {
    services = {
      # Do not add ensureDatabases yet because gitea will add it.
      postgresql = {
        enable = true;
        package = pkgs.postgresql_19;
        ensureDatabases = [ "forgejo" ];
        ensureUsers = [
          {
            name = "forgejo";
            ensureDBOwnership = true;
          }
        ];
      };
      forgejo = {
        enable = true;
        dbBackend = "postgresql";
        useWizard = true;
      };
      cloudflared = {
        enable = true;
        tunnels = {
          ${cloudflared.tunnelId} = {
            default = "http_status:404";
            inherit (cloudflared) ingress;
          };
        };
      };
      wg-quick.configNames = inputs.hosts-secrets.lib.settings.wireguard.configNames.${host} or [ ];
    };
  };

  # ports
  ${namespace}.firewall.ports = [
    80
    443
    45235
  ];
}
