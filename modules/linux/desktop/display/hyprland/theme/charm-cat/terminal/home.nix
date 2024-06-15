{
  imports = [ ../../../../../app/terminal-home.nix ];
  wayland.windowManager.hyprland = {
    settings = {
      # Terminal Kitty
      bind = [ "SUPER,Return,exec,kitty" ];
    };
  };
}
