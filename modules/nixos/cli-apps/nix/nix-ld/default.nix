{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.nix.nix-ld;
in
{
  options.${namespace}.cli-apps.nix.nix-ld = {
    enable = lib.mkEnableOption "nix ld";
  };

  config = lib.mkIf cfg.enable {
    # compatibility
    programs.nix-ld = {
      enable = true;
    };
  };

}
