{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.udisks2;
in
{
  options.${namespace}.services.udisks2 = with types; {
    enable = lib.mkEnableOption "udisks2";
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    # the way to mount disks
    services.udisks2 = {
      enable = true;
    } // cfg.extraOptions;
  };

}
