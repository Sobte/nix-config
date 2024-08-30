{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.useful;
in
{
  options.${namespace}.system.useful = {
    enable = lib.mkEnableOption "system useful";
  };

  config = lib.mkIf cfg.enable {
    system.defaults = {
      LaunchServices = {
        LSQuarantine = false; # disable "this file was downloaded from the internet" warning
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
      };

      CustomUserPreferences = {
        "com.apple.finder" = {
          AppleShowAllFiles = true;
          ShowExternalHardDrivesOnDesktop = false;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
        };
        "com.apple.desktopservices" = {
          # avoid creating .DS_Store files on network or usb volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false; # why not
        };
        "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
        "com.apple.ImageCapture".disableHotPlug = true;
      };
    };
  };
}
