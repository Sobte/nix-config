{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.network.wireless;
in
{
  options.${namespace}.system.network.wireless = {
    enable = lib.mkEnableOption "wireless";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      wireless.iwd.enable = true; # Enables wireless support.
      networkmanager = {
        wifi.backend = "iwd";
      };
    };
  };

}
