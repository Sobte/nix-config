{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.system.kernel;
in
{
  options.${namespace}.system.kernel = with types; {
    enable = lib.mkEnableOption "kernel";
    version = mkOption {
      type = str;
      default = "latest";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelPackages =
      if cfg.version == "latest" then
        pkgs.linuxPackages_latest
      else
        pkgs.linuxKernel.packages."linux_${cfg.version}";
    boot.zfs = lib.mkIf (cfg.version == "latest") {
      package = pkgs.zfs_unstable;
    };
  };
}
