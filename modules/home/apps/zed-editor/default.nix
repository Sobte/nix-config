{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.apps.zed-editor;
in
{
  options.${namespace}.apps.zed-editor = {
    enable = lib.mkEnableOption "zed editor" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    cattery.apps.zed-editor = {
      extraPackages = with pkgs; [
        nixd
      ];
    };
  };

}
