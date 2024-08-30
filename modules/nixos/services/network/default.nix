{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.network;
in
{
  options.${namespace}.services.network = {
    enable = lib.mkEnableOption "network";
  };

  config = lib.mkIf cfg.enable {
    # Easiest to use and most distros use this by default.
    networking.networkmanager.enable = true;
  };

}
