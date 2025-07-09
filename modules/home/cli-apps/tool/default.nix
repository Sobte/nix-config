{
  lib,
  config,
  namespace,
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
    cattery.cli-apps = {
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
