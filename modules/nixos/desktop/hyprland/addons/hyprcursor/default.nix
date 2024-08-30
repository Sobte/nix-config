{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland.addons.hyprcursor;
in
{
  options.${namespace}.desktop.hyprland.addons.hyprcursor = {
    enable = lib.mkEnableOption "hyprcursor";
  };

  config = lib.mkIf cfg.enable {
    # home manager
    ${namespace}.home.extraOptions = {
      home.packages = with pkgs; [
        hyprcursor # cursor theme
      ];
    };
  };
}
