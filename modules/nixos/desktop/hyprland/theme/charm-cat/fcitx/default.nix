{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.fcitx;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.fcitx = {
    enable = lib.mkEnableOption "charm-cat fcitx";
  };

  config = lib.mkIf cfg.enable {
    # home manager
    ${namespace}.home.extraOptions = {

      wayland.windowManager.hyprland = {
        settings = {
          source = [ "${./conf/fcitx.conf}" ];
        };
      };

      xdg.configFile = {
        # preventing nix gc
        "hypr/fcitx" = {
          source = ./conf;
          recursive = true;
        };
      };

    };
  };
}
