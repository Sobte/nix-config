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
      default = config.snowfallorg.user.name or cfg.settings.name or "";
      readOnly = true;
    };
    nickname = mkOption {
      type = nullOr str;
      default = cfg.settings.nickname or cfg.name;
    };
    email = mkOption {
      type = nullOr str;
      default = cfg.settings.email or null;
    };
    settings = mkOption {
      type = attrs;
      default = host;
    };
  };

  config = { };
}
