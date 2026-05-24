{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  inherit (lib) optionalAttrs;

  cfg = config.${namespace}.secrets;
in
{
  options.${namespace}.secrets = {
    enable = lib.mkEnableOption "secrets" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    cattery.secrets =
      lib.${namespace}.secrets
      // (optionalAttrs isDarwin {
        secretsDir = "${config.cattery.user.home}/.secrets";
      })
      // (optionalAttrs isLinux {
        secretsDir = "/run/user/${toString config.home.uid}/agenix";
      });
  };
}
