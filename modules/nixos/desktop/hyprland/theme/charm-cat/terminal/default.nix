{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.terminal;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.terminal = {
    enable = lib.mkEnableOption "charm-cat terminal";
  };

  config = lib.mkIf cfg.enable {
    # home manager
    ${namespace}.home.extraOptions = {

      # kitty
      programs.kitty = {
        enable = true;
      };

      wayland.windowManager.hyprland = {
        settings = {
          # Terminal Kitty
          bind = [ "SUPER,Return,exec,kitty" ];
        };
      };

    };
  };
}
