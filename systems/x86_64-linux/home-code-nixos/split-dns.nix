{
  lib,
  pkgs,
  ...
}:
{
  # Split DNS for the internal suffixes. Only these names use the
  # WireGuard gateway as their resolver; the rest keep the LAN DNS.
  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  systemd.services =
    lib.genAttrs
      [
        "wg-quick-wg-ic-infra"
        "wg-quick-wg-ic-game"
        "wg-quick-wg-ic-mini"
      ]
      (
        name:
        let
          iface = lib.removePrefix "wg-quick-" name;
        in
        {
          after = [ "systemd-resolved.service" ];
          postStart = ''
            ${pkgs.systemd}/bin/resolvectl dns ${iface} 172.25.0.1
            ${pkgs.systemd}/bin/resolvectl domain ${iface} '~ic' '~ic.internal' '~ic.local'
          '';
          preStop = ''
            ${pkgs.systemd}/bin/resolvectl revert ${iface} || true
          '';
        }
      );
}
