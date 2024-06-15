{
  imports = [ ../../../../../app/vscode-home.nix ];
  wayland.windowManager.hyprland = {
    settings = {
      # vscode
      bind = [ "SUPER,V,exec,code" ];
    };
  };
}
