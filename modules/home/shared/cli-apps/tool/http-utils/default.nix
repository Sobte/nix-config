{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.http-utils;
in
{
  options.${namespace}.cli-apps.tool.http-utils = {
    enable = lib.mkEnableOption "http utils";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # cli utils
      wget # fetch thing i don't use
      curl # fetch thing i do use
      aria # no 2 needed
    ];
  };

}
