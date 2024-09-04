{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.kernel-latest;
in
{
  options.${namespace}.system.kernel-latest = {
    enable = lib.mkEnableOption "kernel-latest";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelPackages =
      if config.boot.zfs.enabled then
        config.boot.zfs.package.latestCompatibleLinuxPackages
      else
        pkgs.linuxPackages_latest;
  };

}
