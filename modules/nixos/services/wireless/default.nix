{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.wireless;
in
{
  options.${namespace}.services.wireless = {
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
