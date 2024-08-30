{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.addons.hyprlock;
in
{
  options.${namespace}.desktop.hyprland.addons.hyprlock = {
    enable = lib.mkEnableOption "hyprlock";
  };

  config = lib.mkIf cfg.enable {
    # home manager
    ${namespace}.home.extraOptions = {
      programs.hyprlock = {
        enable = true;
      };
    };

    security.pam.services.hyprlock = { };
  };
}
