{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.convention;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.convention = {
    enable = lib.mkEnableOption "charm-cat convention";
  };

  config = lib.mkIf cfg.enable {
    # home manager
    ${namespace}.home.extraOptions = {

      wayland.windowManager.hyprland = {
        settings = {
          source = [
            "${./conf/base.conf}"
            "${./conf/bind-operate.conf}"
            "${./conf/monitor.conf}"
            "${./conf/rules.conf}"
            "${./conf/style.conf}"
          ];
        };
      };

      xdg.configFile = {
        # preventing nix gc
        "hypr/convention" = {
          source = ./conf;
          recursive = true;
        };
      };

    };
  };

}
