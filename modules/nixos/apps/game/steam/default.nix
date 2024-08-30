{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.game.steam;
in
{
  options.${namespace}.apps.game.steam = {
    enable = lib.mkEnableOption "steam";
  };

  config = lib.mkIf cfg.enable {
    # the app that maximizes my retention
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    hardware.steam-hardware.enable = true;
  };

}
