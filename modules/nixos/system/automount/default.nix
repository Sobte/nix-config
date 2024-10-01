{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.automount;
in
{
  options.${namespace}.system.automount = {
    enable = lib.mkEnableOption "automount";
  };

  config = lib.mkIf cfg.enable {
    services.devmon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
  };

}
