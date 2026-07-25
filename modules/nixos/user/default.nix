{
  lib,
  config,
  namespace,
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
    cattery.user = {
      settings = lib.${namespace}.host;
    };
  };
}
