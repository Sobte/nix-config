{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.thefuck;
in
{
  options.${namespace}.cli-apps.tool.thefuck = {
    enable = lib.mkEnableOption "thefuck";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      # rarely used these days but kinda handy
      thefuck.enable = true;
    };
  };

}
