{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.kde;
in
{
  options.${namespace}.desktop.kde = {
    enable = lib.mkEnableOption "kde";
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.home.extraOptions = {
      home.packages = with pkgs; [ kwalletcli ];
    };

    # sddm for login
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    # plasma6
    services.desktopManager.plasma6.enable = true;
  };

}
