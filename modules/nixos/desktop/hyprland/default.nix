{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland;
in
{
  options.${namespace}.desktop.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {

    ${namespace} = {
      # home manager
      home.extraOptions = {
        wayland.windowManager.hyprland = {
          enable = true;
          # enable hyprland-session.target on hyprland startup.
          systemd.enable = true;
        };
      };
    };

    # hyprland and wayland
    programs.hyprland = {
      # Install the packages from nixpkgs
      enable = true;
      # Whether to enable XWayland
      xwayland.enable = true;
    };
  };

}
