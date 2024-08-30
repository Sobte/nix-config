{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.desktop.wsl;
in
{
  options.${namespace}.room.desktop.wsl = {
    enable = lib.mkEnableOption "room desktop wsl";
  };

  config = lib.mkIf cfg.enable {

    ${namespace} = {
      room.desktop.basis = mkDefaultEnabled;

      system = {
        wsl = mkDefaultEnabled;
      };
    };

    # disable sudo password
    security.sudo.wheelNeedsPassword = false;
  };
}
