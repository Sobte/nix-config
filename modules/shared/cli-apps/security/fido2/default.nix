{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.shared.cli-apps.security.fido2;
in
{
  options.${namespace}.shared.cli-apps.security.fido2 = {
    enable = lib.mkEnableOption "fido2";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libfido2
    ];
  };

}
