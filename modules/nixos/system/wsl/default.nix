{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (config.${namespace}.system.boot) binfmt;

  cfg = config.${namespace}.system.wsl;
in
{
  options.${namespace}.system.wsl = {
    enable = lib.mkEnableOption "wsl";
  };

  config = lib.mkIf cfg.enable {
    # wsl configuration
    wsl = {
      enable = true;
      defaultUser = "${config.${namespace}.user.name}";
      nativeSystemd = true;
      useWindowsDriver = true;
      # docker-desktop.enable = true;
      interop.register = binfmt.enable;
    };
  };

}
