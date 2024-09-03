{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.fastfetch;
in
{
  options.${namespace}.cli-apps.tool.fastfetch = {
    enable = lib.mkEnableOption "fastfetch";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      fastfetch
    ];
  };

}
