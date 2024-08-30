{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.vmware;
in
{
  options.${namespace}.apps.vmware = {
    enable = lib.mkEnableOption "vmware";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.vmware = {
      guest.enable = true;
      host.enable = true;
    };
  };

}
