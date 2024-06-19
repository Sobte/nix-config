{ pkgs, ... }:
{
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
}
