{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.addons.hypridle;
in
{
  options.${namespace}.desktop.hyprland.addons.hypridle = {
    enable = lib.mkEnableOption "hypridle";
  };

  config = lib.mkIf cfg.enable {
    # home manager
    ${namespace}.home.extraOptions = {
      services.hypridle = {
        enable = true;
      };
    };
  };
}
