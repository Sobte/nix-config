{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.boot.binfmt;
in
{
  options.${namespace}.system.boot.binfmt = {
    enable = lib.mkEnableOption "system binfmt";
  };

  config = lib.mkIf cfg.enable {
    # Enable binfmt emulation.
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

}
