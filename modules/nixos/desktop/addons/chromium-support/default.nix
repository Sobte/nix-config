{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.addons.chromium-support;
in
{
  options.${namespace}.desktop.addons.chromium-support = {
    enable = lib.mkEnableOption "chromium support";
  };

  config = lib.mkIf cfg.enable {
    # As of NixOS 22.05 ("Quokka"), you can enable Ozone Wayland support in
    # Chromium and Electron based applications by setting
    # the environment variable NIXOS_OZONE_WL=1. For example, in a configuration.nix:
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

}
