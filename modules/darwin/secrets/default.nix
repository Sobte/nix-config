{
  lib,
  config,
  namespace,
  ...
}:
let
  # user home
  homeDir = config.cattery.user.home;

  cfg = config.${namespace}.secrets;
in
{
  options.${namespace}.secrets = {
    enable = lib.mkEnableOption "secrets" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    cattery.shared.secrets = {
      secretsPath = "${homeDir}/.config/hosts-secrets";
    };
  };
}
