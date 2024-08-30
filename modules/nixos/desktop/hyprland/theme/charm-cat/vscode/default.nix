{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat.vscode;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat.vscode = {
    enable = lib.mkEnableOption "charm-cat vscode";
  };

  config = lib.mkIf cfg.enable {
    # home manager
    ${namespace}.home.extraOptions = {

      programs.vscode = {
        enable = true;
      };

      wayland.windowManager.hyprland = {
        settings = {
          # vscode
          bind = [ "SUPER,V,exec,code" ];
        };
      };

    };
  };
}
