{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.dev-kit.dive;
in
{
  options.${namespace}.cli-apps.dev-kit.dive = {
    enable = lib.mkEnableOption "dive";
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ dive ]; };

}
