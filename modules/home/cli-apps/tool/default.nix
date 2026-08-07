{
  lib,
  config,
  namespace,
  catteryNs,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool;
in
{
  options.${namespace}.cli-apps.tool = {
    enable = lib.mkEnableOption "tool" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    ${catteryNs}.cli-apps = {
      shell = {
        atuin.enable = true;
      };
      tool = {
        useful = {
          enable = true;
          commonAliases = true;
        };
      };
    };
  };
}
