{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (lib.${namespace}) host;
in
{
  options.${namespace}.user = {
    name = mkOption {
      type = types.str;
      default = config.snowfallorg.user.name or host.name;
      readOnly = true;
    };
  };

  config = { };
}
