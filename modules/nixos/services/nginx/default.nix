{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.nginx;
in
{
  options.${namespace}.services.nginx = with types; {
    enable = lib.mkEnableOption "nginx";
    virtualHosts = mkOption {
      type = attrs;
      default = { };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      inherit (cfg) enable virtualHosts;
    } // cfg.extraOptions;
  };
}
