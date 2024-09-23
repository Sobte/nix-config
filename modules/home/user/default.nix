{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (lib.${namespace}) host;

  cfg = config.${namespace}.user;
in
{
  options.${namespace}.user = with types; {
    name = mkOption {
      type = str;
      default = config.snowfallorg.user.name or host.name;
      readOnly = true;
    };
    nickname = mkOption {
      type = nullOr str;
      default = host.nickname or cfg.name;
    };
    email = mkOption {
      type = nullOr str;
      default = host.email or null;
    };
  };

  config = { };
}
