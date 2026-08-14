{
  lib,
  config,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.${namespace}.firewall;
in
{
  options.${namespace}.firewall = with types; {
    enable = lib.mkEnableOption "firewall ports" // {
      default = true;
    };
    ports = mkOption {
      type = listOf port;
      default = [ ];
      description = "Ports opened on both TCP and UDP.";
    };
    tcpPorts = mkOption {
      type = listOf port;
      default = [ ];
      description = "Ports opened on TCP only.";
    };
    udpPorts = mkOption {
      type = listOf port;
      default = [ ];
      description = "Ports opened on UDP only.";
    };
    extraCommands = mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra iptables commands appended to the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = cfg.tcpPorts ++ cfg.ports;
      allowedUDPPorts = cfg.udpPorts ++ cfg.ports;
      inherit (cfg) extraCommands;
    };
  };
}
