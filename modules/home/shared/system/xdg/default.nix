{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.xdg;
in
{
  options.${namespace}.system.xdg = {
    enable = lib.mkEnableOption "xdg";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      xdg-utils
      xdg-user-dirs
    ];

    xdg.enable = true;
  };
}
