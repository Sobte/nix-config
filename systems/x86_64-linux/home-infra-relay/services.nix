{ pkgs, ... }:
{
  cattery = {
    services.sing-box.enable = true;
    system.boot.kernel = {
      useIpForward = true;
      sysctl = {
        "net.ipv4.conf.all.rp_filter" = 0;
      };
    };
  };

  networking = {
    # close firewall
    firewall.enable = false;
    firewall.allowPing = true;

    nftables = {
      enable = true;
      ruleset = ''
        table inet singbox {
          chain prerouting {
            type filter hook prerouting priority mangle; policy accept;

            fib daddr type local return

            ip daddr 10.0.0.0/8 return
            ip daddr 172.16.0.0/12 return
            ip daddr 192.168.0.0/16 return
            ip daddr 127.0.0.0/8 return

            meta l4proto { tcp, udp } meta mark set 1 tproxy to :7895
          }

          chain output {
            type route hook output priority mangle; policy accept;

            meta mark 1 return
          }
        }
      '';
    };
  };

  # route
  systemd.services.setup-tproxy-route = {
    description = "Setup TProxy Routing Table";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = [
        "${pkgs.iproute2}/bin/ip rule add fwmark 1 table 100"
        "${pkgs.iproute2}/bin/ip route add local default dev lo table 100"
      ];
      ExecStop = [
        "${pkgs.iproute2}/bin/ip rule del fwmark 1 table 100"
        "${pkgs.iproute2}/bin/ip route del local default dev lo table 100"
      ];
      PermissionsStartOnly = true;
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
    };
  };

}
