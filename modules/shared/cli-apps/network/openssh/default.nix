{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.shared.cli-apps.network.openssh;
in
{
  options.${namespace}.shared.cli-apps.network.openssh = {
    enable = lib.mkEnableOption "openssh";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openssh
    ];
  };

}
