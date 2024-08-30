{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.monitoring;
in
{
  options.${namespace}.cli-apps.tool.monitoring = {
    enable = lib.mkEnableOption "monitoring";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # tui
      btop
      htop
      glances
      inxi # yep i have 4 monitoring tools for some reason
    ];
  };

}
