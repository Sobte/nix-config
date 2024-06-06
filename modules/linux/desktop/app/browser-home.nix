{ pkgs, ... }:
{
  # the linux browser (TM)
  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox-devedition-bin;
    };

    # chromium for google
    chromium = {
      enable = true;
      package = pkgs.google-chrome;
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
}
