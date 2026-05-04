{
  lib,
  config,
  namespace,
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
    cattery.secrets = lib.${namespace}.secrets;
  };
}
