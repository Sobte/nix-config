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
          # Steam Proton/Wine prefix (game data) path:
          # ~/.steam/steam/steamapps/compatdata/<AppID>/pfx/drive_c/
          # Example: Portal 2 (AppID 620) https://store.steampowered.com/app/620/Portal_2/
          data.directories = [
            "Last Call BBS"
            "shapez.io"
            "Tabletop Simulator"
            "Draw&Guess"
            "UnrailedGame"
            "Opus Magnum"
          ];
          config.directories = [
            # Unity Game
            "unity3d"
            "blender"
          ];
        };
      };
    };
  };

}
