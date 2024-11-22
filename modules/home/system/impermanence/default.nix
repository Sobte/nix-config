{
  lib,
  config,
  namespace,
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
    cattery.system.impermanence = {
      directories = [
        # steam games
        ".factorio"
      ];
      xdg = {
        config.directories = [
          "nix-config"
          "hosts-secrets"
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
