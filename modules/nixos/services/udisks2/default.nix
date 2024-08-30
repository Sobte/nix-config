{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.udisks2;
in
{
  options.${namespace}.services.udisks2 = {
    enable = lib.mkEnableOption "udisks2";
  };

  config = lib.mkIf cfg.enable {
    # the way to mount disks
    services.udisks2.enable = true;
  };

}
