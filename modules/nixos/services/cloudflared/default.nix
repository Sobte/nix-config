{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types concatMapAttrs;

  cfg = config.${namespace}.services.cloudflared;
in
{
  options.${namespace}.services.cloudflared = with types; {
    enable = lib.mkEnableOption "cloudflared";
    tunnels = mkOption {
      type = attrs;
      default = { };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.cloudflared = {
      inherit (cfg) enable;
      tunnels = concatMapAttrs (name: tunnel: {
        ${name} = {
          credentialsFile = "/etc/cloudflared/credentials/${name}.json";
        } // tunnel;
      }) cfg.tunnels;
    } // cfg.extraOptions;
  };
}
