{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.addons.hyprshot;
in
{
  options.${namespace}.desktop.hyprland.addons.hyprshot = {
    enable = lib.mkEnableOption "hyprshot";
  };

  config = lib.mkIf cfg.enable {
    # home manager
    ${namespace}.home.extraOptions = {
      home.packages = with pkgs; [
        hyprshot # screenshot
        wl-clipboard # for hyprshot
        grim # for hyprshot
        slurp # for hyprshot
      ];

      # examples: -m output -o ~/Pictures/Screenshots -- nomacs
    };
  };

}
