{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.cron;
in
{
  options.${namespace}.services.cron = {
    enable = lib.mkEnableOption "cron";
  };

  config = lib.mkIf cfg.enable { services.cron.enable = true; };

}
