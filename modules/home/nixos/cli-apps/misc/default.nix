{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.cli-apps.misc;
in
{
  options.${namespace}.cli-apps.misc = {
    enable = lib.mkEnableOption "misc";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      psmisc # killall
      usbutils # lsusb
    ];
  };

}
