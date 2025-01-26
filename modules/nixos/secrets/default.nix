{
  lib,
  config,
  namespace,
  ...
}:
let
  inherit (lib) optionalString;

  # user home
  homeDir = config.cattery.user.home;
  persistent = config.cattery.system.impermanence;
  cfg = config.${namespace}.secrets;
in
{
  options.${namespace}.secrets = {
    enable = lib.mkEnableOption "secrets" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    cattery.secrets = {
      enable = true;
      secretsPath = "${optionalString persistent.enable "/persistent"}${homeDir}/.config/hosts-secrets";
    };

  };
}
