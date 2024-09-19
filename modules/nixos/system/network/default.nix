{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.network;
in
{
  options.${namespace}.system.network = {
    enable = lib.mkEnableOption "network";
  };

  config = lib.mkIf cfg.enable {
    # Easiest to use and most distros use this by default.
    networking.networkmanager.enable = true;
  };

}
