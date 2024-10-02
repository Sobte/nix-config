{
  lib,
  config,
  namespace,
  ...
}:
let
  inherit (config.cattery.user) name;

  cfg = config.${namespace}.user;
in
{
  options.${namespace}.user = {
    enable = lib.mkEnableOption "user" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # disable automatic creation. enabling it will mess up my configuration.
    snowfallorg.users.${name}.create = false;
    cattery.user = {
      settings = lib.${namespace}.host;
    };
  };
}
