{
  lib,
  config,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.impermanence;
in
{
  options.${namespace}.system.impermanence = {
    enable = lib.mkEnableOption "impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    cattery.system.impermanence = {
      xdg.config.directories = [
        "nix-config"
        "hosts-secrets"
      ];
    };
  };
}
