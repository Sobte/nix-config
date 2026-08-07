{
  lib,
  config,
  namespace,
  catteryNs,
  ...
}:
let
  cfg = config.${namespace}.apps.browser;
in
{
  options.${namespace}.apps.browser = {
    enable = lib.mkEnableOption "browser" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    ${catteryNs}.apps.browser = {
      needs = [ "chrome" ];
    };
  };
}
