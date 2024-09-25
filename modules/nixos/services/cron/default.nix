{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.cron;
in
{
  options.${namespace}.services.cron = with types; {
    enable = lib.mkEnableOption "cron";
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.cron = {
      enable = true;
    } // cfg.extraOptions;
  };
}
