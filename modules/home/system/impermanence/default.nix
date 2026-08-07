{
  lib,
  config,
  namespace,
  catteryNs,
  ...
}:
let
  cfg = config.${namespace}.system.impermanence;
in
{
  options.${namespace}.system.impermanence = {
    enable = lib.mkEnableOption "impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    ${catteryNs}.system.impermanence = {
      xdg = {
        config.directories = [
          "nix-config"
        ];
        data.files = [
          # dolphin user-places
          "user-places.xbel"
          "user-places.xbel.bak"
          "user-places.xbel.tbcache"
        ];
      };
    };
  };
}
