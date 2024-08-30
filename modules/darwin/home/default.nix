{
  options,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption mkAliasDefinitions types;
in
{
  options.${namespace}.home = with types; {
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = {
    # home manager config
    snowfallorg.user.${config.${namespace}.user.name}.home.config =
      mkAliasDefinitions
        options.${namespace}.home.extraOptions;
  };
}
