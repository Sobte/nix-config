{
  lib,
  config,
  namespace,
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
    cattery.apps.browser = {
      needs = [ "chrome" ];
    };
  };
}
