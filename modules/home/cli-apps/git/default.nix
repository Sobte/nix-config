{
  lib,
  config,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.git;
in
{
  options.${namespace}.cli-apps.git = {
    enable = lib.mkEnableOption "git" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    cattery.cli-apps.dev-kit.git = {
      inherit (lib.${namespace}.host) sendEmail;
    };
  };
}
