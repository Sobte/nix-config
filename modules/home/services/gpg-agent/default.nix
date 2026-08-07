{
  lib,
  config,
  namespace,
  catteryNs,
  ...
}:
let
  cfg = config.${namespace}.services.gpg-agent;
in
{
  options.${namespace}.services.gpg-agent = {
    enable = lib.mkEnableOption "gpg-agent" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    ${catteryNs}.services.gpg-agent = {
      enable = lib.mkDefault true;
      enableExtraSocket = lib.mkDefault true;
      verbose = lib.mkDefault true;
    };
  };
}
