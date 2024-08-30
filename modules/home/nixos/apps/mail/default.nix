{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.mail;
in
{
  options.${namespace}.apps.mail = {
    enable = lib.mkEnableOption "mail";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      thunderbird # email client
    ];
  };

}
