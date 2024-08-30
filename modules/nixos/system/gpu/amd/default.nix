{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.gpu.amd;
in
{
  options.${namespace}.system.gpu.amd = {
    enable = lib.mkEnableOption "amd gpu";
  };

  config = lib.mkIf cfg.enable {
    # use amd gpu driver
    boot.initrd.kernelModules = [ "amdgpu" ];
  };

}
