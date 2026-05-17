{
  pkgs,
  lib,
  system,
  inputs,
  host,
  ...
}:
let
  domain = "pve002.home.host.oop.icu";
in
{
  cattery = {
    system.network.enable = false;
    services = {
      acme = {
        useRoot = true;
        certs.${domain} = { };
      };
      wg-quick.configNames = [ "wg-come-home" ];
    };
  };

  # import pve pkgs
  nixpkgs.overlays = with inputs; [
    proxmox-nixos.overlays.${system}
  ];

  # fix
  services.openssh.settings = {
    AcceptEnv = lib.mkForce [
      "LANG"
      "LC_*"
    ];
  };

  # pve
  services.proxmox-ve = {
    enable = true;
    ipAddress = inputs.hosts-secrets.lib.keys.computed.${host}.endpoint.hostName;
  };

  # pve zfs (optional)
  networking.hostId = "40f55cd5"; # head -c 8 /etc/machine-id
  boot.supportedFilesystems = [ "zfs" ];
  environment.systemPackages = [ pkgs.zfs ];

  # systemd network
  networking.useNetworkd = true;

  # Make vmbr0 bridge visible in Proxmox web interface
  services.proxmox-ve.bridges = [ "vmbr0" ];

  # Actually set up the vmbr0 bridge
  systemd.network.networks."10-lan" = {
    matchConfig.Name = [
      "enp1s0"
      "enp2s0"
    ];
    networkConfig = {
      Bridge = "vmbr0";
      DHCP = "no";
      IPv6AcceptRA = false;
    };
    linkConfig = {
      RequiredForOnline = "no";
    };
  };

  systemd.network.netdevs."vmbr0" = {
    netdevConfig = {
      Name = "vmbr0";
      Kind = "bridge";
    };
  };

  systemd.network.networks."10-vmbr0" = {
    matchConfig.Name = "vmbr0";
    networkConfig = {
      IPv6AcceptRA = true;
      DHCP = "ipv4";
    };
    linkConfig.RequiredForOnline = "routable";
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
