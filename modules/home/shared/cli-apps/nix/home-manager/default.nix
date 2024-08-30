{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.nix.home-manager;
in
{
  options.${namespace}.cli-apps.nix.home-manager = {
    enable = lib.mkEnableOption "home manager";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      # let home-manager install and manage itself
      home-manager.enable = true;
    };
  };

}
