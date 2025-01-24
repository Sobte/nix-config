{
  lib,
  config,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.cattery) user;

  cfg = config.${namespace}.desktop.addons.catppuccin;
in
{
  options.${namespace}.desktop.addons.catppuccin = with types; {
    enable = lib.mkEnableOption "catppuccin" // {
      default = true;
    };
    sddm = mkOption {
      type = attrs;
      default = user.settings.catppuccin.sddm or { };
    };
  };

  config = lib.mkIf cfg.enable {
    catppuccin.sddm = cfg.sddm;
  };
}
