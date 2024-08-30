{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;

  cfg = config.${namespace}.cli-apps.shell.powershell;
in
{
  options.${namespace}.cli-apps.shell.powershell = {
    enable = lib.mkEnableOption "powershell";
  };

  config = lib.mkIf (cfg.enable && isDarwin) { home.packages = with pkgs; [ powershell ]; };

}
