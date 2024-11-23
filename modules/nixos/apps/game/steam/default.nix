{
  config,
  lib,
  namespace,
  ...
}:
let
  catCfg = config.cattery.apps.game.steam;

  cfg = config.${namespace}.apps.game.steam;
in
{
  options.${namespace}.apps.game.steam = {
    enable = lib.mkEnableOption "steam persistence" // {
      default = catCfg.enable && catCfg.persistence;
    };
  };

  config = lib.mkIf cfg.enable {
    cattery.home.extraOptions = {
      cattery.system.impermanence = {
        directories = [
          ".factorio"
        ];
        xdg = {
          data.directories = [
            "Last Call BBS"
            "shapez.io"
            "Tabletop Simulator"
            "Draw&Guess"
          ];
          config.directories = [
            "unity3d"
            "blender"
          ];
        };
      };
    };
  };

}
