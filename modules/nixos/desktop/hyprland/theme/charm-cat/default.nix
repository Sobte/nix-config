{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.desktop.hyprland.theme.charm-cat;
in
{
  options.${namespace}.desktop.hyprland.theme.charm-cat = {
    enable = lib.mkEnableOption "charm-cat theme";
  };

  config = lib.mkIf cfg.enable {
    # sddm for login
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    ${namespace}.desktop.hyprland = {
      enable = mkDefault true;
      theme.charm-cat = {
        convention = mkDefaultEnabled;
        fcitx = mkDefaultEnabled;
        file-manager = mkDefaultEnabled;
        launcher = mkDefaultEnabled;
        lock-screen = mkDefaultEnabled;
        notification = mkDefaultEnabled;
        screenshots = mkDefaultEnabled;
        terminal = mkDefaultEnabled;
        vscode = mkDefaultEnabled;
        waybar = mkDefaultEnabled;
        wlogout = mkDefaultEnabled;
      };
    };
  };
}
