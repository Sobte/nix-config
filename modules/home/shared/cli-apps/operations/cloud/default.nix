{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.operations.cloud;
in
{
  options.${namespace}.cli-apps.operations.cloud = {
    enable = lib.mkEnableOption "cloud";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # cloud
      turso-cli
      awscli2
    ];
  };

}
