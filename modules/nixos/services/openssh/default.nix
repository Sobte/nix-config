{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.openssh;
in
{
  options.${namespace}.services.openssh = with types; {
    enable = lib.mkEnableOption "openssh";
    X11Forwarding = lib.mkEnableOption "Whether to allow X11 connections to be forwarded.";
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      # enable openssh
      enable = true;
      settings.X11Forwarding = cfg.X11Forwarding;
    } // cfg.extraOptions;
  };

}
