{
  inputs,
  pkgs,
  host,
  namespace,
  catteryNs,
  ...
}:
{
  imports = [
    # ./disk.nix
    ./hardware.nix
  ];

  ${namespace} = {
    # ports
    firewall.ports = [ 58753 ];
  };

  # Aliyun ECS with two ENIs in the same subnet (10.5.6.0/24):
  #   ens5 = 10.5.6.121  -> public 112.124.42.234
  #   ens6 = 10.5.6.122  -> public 47.96.1.209
  # Replies must egress the same NIC the connection arrived on, otherwise
  # Aliyun's NAT for ens6 (47.96.1.209) never sees return traffic and that
  # public IP is unreachable. This needs source-based policy routing.
  # Run it from a NetworkManager dispatcher (NICs are managed by NM) instead of
  # networking.localCommands, which fires too early during boot while the NICs
  # are still down ("Device for nexthop is not up").
  # NB: add the connected route before the default route, or the kernel
  # rejects the latter with "Nexthop has invalid gateway".
  networking.networkmanager.dispatcherScripts = [
    {
      type = "basic";
      source = pkgs.writeShellScript "dual-nic-policy-routing" ''
        ip="${pkgs.iproute2}/bin/ip"
        [ "$2" = "up" ] || exit 0
        case "$1" in
          ens6)
            # ens6 -> table 100
            $ip route replace 10.5.6.0/24 dev ens6 table 100
            $ip route replace default via 10.5.6.253 dev ens6 table 100
            $ip rule del from 10.5.6.122 lookup 100 priority 1000 2>/dev/null || true
            $ip rule add from 10.5.6.122 lookup 100 priority 1000
            ;;
          ens5)
            # ens5 -> table 101
            $ip route replace 10.5.6.0/24 dev ens5 table 101
            $ip route replace default via 10.5.6.253 dev ens5 table 101
            $ip rule del from 10.5.6.121 lookup 101 priority 1001 2>/dev/null || true
            $ip rule add from 10.5.6.121 lookup 101 priority 1001
            ;;
        esac
      '';
    }
  ];

  ${catteryNs} = {
    user.name = "root"; # use root as default user
    # Enable EFI boot support
    system.boot.efi.enable = true;
    room.server.enable = true;
    services.wg-quick.configNames =
      inputs.hosts-secrets.lib.settings.wireguard.configNames.${host} or [ ];
    system.boot.kernel = {
      useIpForward = true;
      sysctl = {
        "net.ipv4.conf.all.rp_filter" = 2;
        "net.ipv4.conf.default.rp_filter" = 2;
        "net.ipv4.conf.ens6.rp_filter" = 2; # 替换为你的辅助网卡名称（如 eth1 / enp1s0）
      };
    };
  };

}
