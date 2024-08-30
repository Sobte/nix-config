{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.desktop.game;
in
{
  options.${namespace}.room.desktop.game = {
    enable = lib.mkEnableOption "room desktop game";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.desktop.general = mkDefaultEnabled;

      apps = {
        game.steam = mkDefaultEnabled;
      };
    };

    # disable sudo password
    security.sudo.wheelNeedsPassword = false;
  };
}
