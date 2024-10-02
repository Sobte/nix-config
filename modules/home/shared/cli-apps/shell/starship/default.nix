{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.${namespace}.user) settings;

  cfg = config.${namespace}.cli-apps.shell.starship;
in
{
  options.${namespace}.cli-apps.shell.starship = with types; {
    enable = lib.mkEnableOption "starship";
    settings = mkOption {
      type = attrs;
      default = settings.starship.settings or { };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      # used to use headline, tho kinda slow, so switched to starship
      starship = {
        inherit (cfg) settings;
        enable = true;
      };
    };
  };

}
