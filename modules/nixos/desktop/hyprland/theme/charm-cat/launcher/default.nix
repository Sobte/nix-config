{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.launcher;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.launcher = {
    enable = lib.mkEnableOption "charm-cat launcher";
  };

  config = lib.mkIf cfg.enable {
    # home manager
    ${namespace}.home.extraOptions = {

      home.packages = with pkgs; [ ulauncher ];

      wayland.windowManager.hyprland = {
        settings = {
          source = [ "${./conf/ulauncher.conf}" ];
        };
      };

      xdg.configFile = {
        # preventing nix gc
        "hypr/ulauncher" = {
          source = ./conf;
          recursive = true;
        };
      };

    };
  };
}
