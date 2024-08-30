{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.dev-kit.lua;
in
{
  options.${namespace}.cli-apps.dev-kit.lua = {
    enable = lib.mkEnableOption "lua";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # lua
      luajit
    ];
  };

}
