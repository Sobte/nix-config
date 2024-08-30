{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.database.sqlite;
in
{
  options.${namespace}.cli-apps.database.sqlite = {
    enable = lib.mkEnableOption "sqlite";
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ sqlite ]; };

}
