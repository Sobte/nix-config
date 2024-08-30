{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.network;
in
{
  options.${namespace}.cli-apps.tool.network = {
    enable = lib.mkEnableOption "network";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # network
      inetutils # telnet / ping
    ];
  };

}
