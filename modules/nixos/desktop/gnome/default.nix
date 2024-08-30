{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.gnome;
in
{
  options.${namespace}.desktop.gnome = {
    enable = lib.mkEnableOption "gnome";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;

      desktopManager.gnome.enable = true;
      # GNOME Display Manager
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

}
