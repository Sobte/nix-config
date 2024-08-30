{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.desktop.general;
in
{
  options.${namespace}.room.desktop.general = {
    enable = lib.mkEnableOption "room desktop general";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.desktop.basis = mkDefaultEnabled;

      apps = {
        vscode = mkDefaultEnabled;
      };

      # linux config
      apps = {
        browser = mkDefaultEnabled;
      };
    };
  };
}
