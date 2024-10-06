{
  lib,
  config,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.security;
in
{
  options.${namespace}.security = {
    enable = lib.mkEnableOption "security" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    cattery.cli-apps.security = {
      gnupg.agent = {
        enable = lib.mkDefault true;
        enableSSHSupport = lib.mkDefault true;
      };
    };
  };
}
