{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.dev-kit.go;
in
{
  options.${namespace}.cli-apps.dev-kit.go = {
    enable = lib.mkEnableOption "go";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # go
      go
    ];
  };

}
