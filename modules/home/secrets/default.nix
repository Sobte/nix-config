{
  pkgs,
  lib,
  config,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) optionalString;
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
    cattery.secrets = {
      enable = true;
      secretsPath = "${optionalString isLinux "/persistent"}${homeDir}/.config/hosts-secrets";
    };
  };
}
