{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.notification;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.notification = {
    enable = lib.mkEnableOption "charm-cat notification";
  };

  config = lib.mkIf cfg.enable {
    # home manager
    ${namespace}.home.extraOptions = {

      home.packages = with pkgs; [
        mako # the notification daemon, the same as dunst
      ];

      wayland.windowManager.hyprland = {
        settings = {
          exec-once = [ "mako" ];
        };
      };

    };
  };
}
