{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.basis;
in
{
  options.${namespace}.room.basis = {
    enable = lib.mkEnableOption "room basis";
  };

  config = lib.mkIf cfg.enable {

    ${namespace} = {
      brew = mkDefaultEnabled;
      nix = mkDefaultEnabled;
      system = {
        sudoTouch = mkDefaultEnabled;
        useful = mkDefaultEnabled;
      };

      # shared
      shared = {
        nix = mkDefaultEnabled;
        cli-apps.shell.zsh = mkDefaultEnabled;
        system = {
          fonts = mkDefaultEnabled;
          ulimit = {
            enable = mkDefault true;
            openFilesLimit = 4096;
          };
        };
      };
    };

  };
}
