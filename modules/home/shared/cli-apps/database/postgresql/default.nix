{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.database.postgresql;
in
{
  options.${namespace}.cli-apps.database.postgresql = {
    enable = lib.mkEnableOption "postgresql";
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ postgresql_16_jit ]; };

}
