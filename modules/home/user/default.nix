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
      addToAccounts = true;
      settings = lib.${namespace}.host // {
        inherit (config.snowfallorg.user) name;
      };
    };
  };
}
