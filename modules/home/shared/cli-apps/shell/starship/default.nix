{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.shell.starship;
in
{
  options.${namespace}.cli-apps.shell.starship = {
    enable = lib.mkEnableOption "starship";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      # used to use headline, tho kinda slow, so switched to starship
      starship = {
        enable = true;
        # using toml here to benefit from schema & lsp
        settings = builtins.fromTOML (builtins.readFile ./config/starship.toml);
      };
    };
  };

}
