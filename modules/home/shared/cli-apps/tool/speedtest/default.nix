{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.speedtest;
in
{
  options.${namespace}.cli-apps.tool.speedtest = {
    enable = lib.mkEnableOption "speedtest";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      speedtest-cli
      speedtest-go
    ];
  };

}
