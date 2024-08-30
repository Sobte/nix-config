{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.file-manager;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.file-manager = {
    enable = lib.mkEnableOption "charm-cat file manager";
  };

  config = lib.mkIf cfg.enable {
    # home manager
    ${namespace}.home.extraOptions = {
      home.packages = with pkgs; [ xfce.thunar ];

      wayland.windowManager.hyprland = {
        settings = {
          # Xfce Thunar
          bind = [ "SUPER,E,exec,thunar" ];
        };
      };

    };
  };
}
