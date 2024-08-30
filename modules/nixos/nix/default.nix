{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.nix;
in
{
  options.${namespace}.nix = {
    enable = lib.mkEnableOption "nix";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      gc = {
        automatic = true;
        persistent = true;
        dates = "0/4:0"; # expands to "*-*-* 00/04:00:00"
        randomizedDelaySec = "45min";
        options = "--delete-older-than 30d";
      };
    };
  };

}
