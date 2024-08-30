{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.time;
in
{
  options.${namespace}.system.time = {
    enable = lib.mkEnableOption "time";
  };

  config = lib.mkIf cfg.enable { time.timeZone = "Asia/Shanghai"; };

}
