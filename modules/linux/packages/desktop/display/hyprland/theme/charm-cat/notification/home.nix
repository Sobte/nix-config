{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mako # the notification daemon, the same as dunst
  ];

  wayland.windowManager.hyprland = {
    settings = {
      exec-once = [ "mako" ];
    };
  };
}
