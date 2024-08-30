{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.lightdm;
in
{
  options.${namespace}.desktop.lightdm = {
    enable = lib.mkEnableOption "lightdm";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
    };
  };

}
