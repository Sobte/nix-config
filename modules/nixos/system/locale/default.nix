{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.locale;
in
{
  options.${namespace}.system.locale = {
    enable = lib.mkEnableOption "locale";
  };

  config = lib.mkIf cfg.enable { i18n.defaultLocale = "en_US.UTF-8"; };

}
