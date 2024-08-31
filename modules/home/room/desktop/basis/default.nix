{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.desktop.basis;
in
{
  options.${namespace}.room.desktop.basis = {
    enable = lib.mkEnableOption "room desktop basis";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.basis = mkDefaultEnabled;

      system = {
        xdg = mkDefaultEnabled;
      };

      # linux config
      apps = {
        graphics = mkDefaultEnabled;
        useful = mkDefaultEnabled;
      };
    };
  };
}
