{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types concatMapAttrs;

  cfg = config.${namespace}.system.network.bridges;

  # type
  bridgeType = types.submodule {
    options = with types; {
      interfaces = mkOption {
        example = [
          "eth0"
          "eth1"
        ];
        type = listOf str;
        description = "The physical network interfaces connected by the bridge.";
      };
      rstp = mkOption {
        default = false;
        type = bool;
        description = "Whether the bridge interface should enable rstp.";
      };
      ipv4 = mkOption {
        default = { };
        type = attrs;
        description = "IPv4 configuration for the bridge interface. just like the 'networking.interfaces.<name>.ipv4' option.";
      };
      ipv6 = mkOption {
        default = { };
        type = attrs;
        description = "IPv6 configuration for the bridge interface. just like the 'networking.interfaces.<name>.ipv6' option.";
      };
      useDHCP = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = ''
          Whether this interface should be configured with DHCP. Overrides the
          default set by {option}`networking.useDHCP`. If `null` (the default),
          DHCP is enabled if the interface has no IPv4 addresses configured
          with {option}`networking.interfaces.<name>.ipv4.addresses`, and
          disabled otherwise.
        '';
      };
    };
  };
in
{
  options.${namespace}.system.network.bridges = mkOption {
    type = types.attrsOf bridgeType;
    default = { };
    description = "network bridges";
  };

  config = {
    networking = {
      bridges = concatMapAttrs (name: bridge: {
        ${name} = {
          inherit (bridge) interfaces rstp;
        };
      }) cfg;
      interfaces = concatMapAttrs (name: bridge: {
        ${name} = {
          inherit (bridge) ipv4 ipv6 useDHCP;
        };
      }) cfg;
    };
  };
}
