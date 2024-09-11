{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.openssh;
in
{
  options.${namespace}.services.openssh = {
    enable = lib.mkEnableOption "openssh";
    X11Forwarding = lib.mkEnableOption "Whether to allow X11 connections to be forwarded.";
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      # enable openssh
      enable = true;
      settings.X11Forwarding = cfg.X11Forwarding;
    };
  };

}
