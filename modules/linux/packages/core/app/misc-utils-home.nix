{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      psmisc # killall
      usbutils # lsusb
    ];
  };
}
