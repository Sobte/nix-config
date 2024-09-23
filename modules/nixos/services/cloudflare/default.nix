{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.cloudflare;
in
{
  options.${namespace}.services.cloudflare = with types; {
    enable = lib.mkEnableOption "cloudflare";
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.cloudflared = {
      inherit (cfg) enable;
    } // cfg.extraOptions;
  };
}
