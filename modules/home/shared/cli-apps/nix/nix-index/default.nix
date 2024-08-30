{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.nix.nix-index;
in
{
  options.${namespace}.cli-apps.nix.nix-index = {
    enable = lib.mkEnableOption "nix index";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      # command not found in nix
      nix-index.enable = true;
    };
  };

}
