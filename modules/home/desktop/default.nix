{
  lib,
  config,
  namespace,
  catteryNs,
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
    ${catteryNs}.desktop.xdg = {
      app = {
        editor = [
          "dev.zed.Zed.desktop"
          "code-insiders.desktop"
          "code.desktop"
          "cursor.desktop"
        ];
      };
    };
  };
}
