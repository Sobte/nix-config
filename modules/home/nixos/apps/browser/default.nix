{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.browser;
in
{
  options.${namespace}.apps.browser = {
    enable = lib.mkEnableOption "browser";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    # the linux browser (TM)
    programs = {
      firefox = {
        enable = true;
        package = pkgs.firefox-devedition-bin;
      };

      # google chrome
      # source code: https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix
      google-chrome = {
        enable = true;
        commandLineArgs = [
          "--ozone-platform=wayland"
          "--enable-wayland-ime"
        ];
      };

      # browserpass for password management
      browserpass = {
        enable = true;
        browsers = [ "chrome" ];
      };
    };
  };

}
