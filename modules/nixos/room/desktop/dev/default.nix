{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.desktop.dev;
in
{
  options.${namespace}.room.desktop.dev = {
    enable = lib.mkEnableOption "room desktop dev";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.desktop.general = mkDefaultEnabled;

      apps = {
        yubikey = mkDefaultEnabled;
      };

      services = {
        docker = mkDefaultEnabled;
        vscode-server = mkDefaultEnabled;
      };

      system.boot.binfmt = mkDefaultEnabled;
    };

    # disable sudo password
    security.sudo.wheelNeedsPassword = false;
  };
}
