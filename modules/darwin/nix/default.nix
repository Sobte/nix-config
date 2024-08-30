{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.nix;
in
{
  options.${namespace}.nix = {
    enable = lib.mkEnableOption "nix";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      gc = {
        user = "root";
        automatic = true;
        interval = {
          Weekday = 0;
          Hour = 4;
          Minute = 0;
        };
        options = "--delete-older-than 30d";
      };
    };

    # auto upgrade nix package and the daemon service
    services.nix-daemon.enable = true;
  };
}
