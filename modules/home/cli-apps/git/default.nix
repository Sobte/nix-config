{
  lib,
  config,
  namespace,
  catteryNs,
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
    ${catteryNs}.cli-apps.dev-kit.git = config.${catteryNs}.user.settings.git or { };
  };
}
