{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.acme-sh;
in
{
  options.${namespace}.cli-apps.tool.acme-sh = {
    enable = lib.mkEnableOption "acme.sh";
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ acme-sh ]; };

}
