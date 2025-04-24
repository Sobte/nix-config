{
  lib,
  config,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop;
in
{
  options.${namespace}.desktop = {
    enable = lib.mkEnableOption "desktop" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    cattery.desktop.xdg = {
      app = {
        editor = [
          "cursor.desktop"
          "dev.zed.Zed.desktop"
          "code-insiders.desktop"
          "code.desktop"
        ];
      };
    };
  };
}
