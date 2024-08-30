{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.sudoTouch;
in
{
  options.${namespace}.system.sudoTouch = {
    enable = lib.mkEnableOption "system sudo touch id auth";
  };

  config = {
    security.pam.enableSudoTouchIdAuth = cfg.enable;
  };
}
