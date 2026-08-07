{
  lib,
  config,
  namespace,
  catteryNs,
  ...
}:
let
  cfg = config.${namespace}.secrets;
in
{
  options.${namespace}.secrets = {
    enable = lib.mkEnableOption "secrets" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    ${catteryNs}.secrets = lib.${namespace}.secrets;
  };
}
