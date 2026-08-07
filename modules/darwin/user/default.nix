{
  lib,
  config,
  namespace,
  catteryNs,
  ...
}:
let
  cfg = config.${namespace}.user;
in
{
  options.${namespace}.user = {
    enable = lib.mkEnableOption "user" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    ${catteryNs}.user = {
      settings = lib.${namespace}.host;
    };
  };
}
