{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.instant-messengers;
in
{
  options.${namespace}.apps.instant-messengers = {
    enable = lib.mkEnableOption "instant messengers";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      telegram-desktop
      vesktop # replace discord
    ];
  };
}
