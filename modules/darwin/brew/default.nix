{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.brew;
in
{
  options.${namespace}.brew = {
    enable = lib.mkEnableOption "brew";
  };

  config = lib.mkIf cfg.enable {
    cattery.brew = {
      casks = [
        "google-chrome"
        "jetbrains-toolbox"
        "thunderbird" # email client
        "microsoft-remote-desktop" # remote desktop client
        "signal" # instant messaging application focusing on security
        "obsidian" # obsidian
        "snipaste" # screen capture tool
        "battery" # managing battery charging
      ];
    };
  };

}
