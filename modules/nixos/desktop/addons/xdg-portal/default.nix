{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.addons.xdg-portal;
in
{
  options.${namespace}.desktop.addons.xdg-portal = {
    enable = lib.mkEnableOption "xdg portal";
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      portal = {
        enable = true;
      };
    };
  };

}
