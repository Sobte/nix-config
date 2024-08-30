{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.security.gnupg;
in
{
  options.${namespace}.cli-apps.security.gnupg = {
    enable = lib.mkEnableOption "gnupg";
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ gnupg ]; };

}
