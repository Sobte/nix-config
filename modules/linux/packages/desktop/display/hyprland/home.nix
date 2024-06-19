{ pkgs, inputs, ... }:
{
  wayland.windowManager.hyprland = {
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    enable = true;
    # enable hyprland-session.target on hyprland startup.
    systemd.enable = true;
  };
}
