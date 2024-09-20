{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.system.network.nat;
in
{
  options.${namespace}.system.network.nat = with types; {
    enable = lib.mkEnableOption "network nat";
    enableIPv6 = mkOption {
      type = bool;
      # Lazy IPv6 connectivity for the container
      default = true;
      description = ''
        Whether to enable IPv6 NAT.
      '';
    };
    internalInterfaces = mkOption {
      type = listOf str;
      default = [ "ve-+" ];
      example = [
        "eth0"
        "ve-+"
      ];
      description = ''
        The interfaces for which to perform NAT. Packets coming from
        these interface and destined for the external interface will
        be rewritten.
      '';
    };
    externalInterface = mkOption {
      type = nullOr str;
      default = null;
      example = "eth1";
      description = ''
        The name of the external network interface.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.nat = {
      inherit (cfg)
        enable
        internalInterfaces
        externalInterface
        enableIPv6
        ;
    };
  };
}
