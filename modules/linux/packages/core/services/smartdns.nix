let
  ports = [
    53
    853
    443
  ];
in
{
  # dns ports
  networking.firewall = {
    allowedUDPPorts = ports;
    allowedTCPPorts = ports;
  };

  services.smartdns = {
    enable = true;
    # manual: https://pymumu.github.io/smartdns/configuration/
    settings = {
      bind = "[::]:53";
      bind-tcp = "[::]:53";
      tcp-idle-time = 120;
      bind-tls = "[::]:853";
      bind-https = "[::]:443";
      bind-cert-file = "/etc/smartdns/cert.pem";
      bind-cert-key-file = "/etc/smartdns/key.pem";
      cache-size = 32768;
      force-qtype-SOA = 65;
      log-level = "info";
      server-tls = [
        "8.8.8.8:853"
        "1.1.1.1:853"
      ];
      server-https = "https://cloudflare-dns.com/dns-query";
      speed-check-mode = "ping,tcp:80,tcp:443";
      prefetch-domain = true;
      serve-expired = true;
      serve-expired-ttl = 259200;
      serve-expired-reply-ttl = 3;
      serve-expired-prefetch-time = 21600;
    };
  };
}
