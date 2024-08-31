{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.shared.system.ulimit;
in
{
  options.${namespace}.shared.system.ulimit = {
    enable = lib.mkEnableOption "ulimit";
    openFilesLimit = mkOption {
      type = types.int;
      default = 2048;
    };
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.home.extraOptions = {
      programs = {
        zsh.initExtra = lib.mkAfter ''
          # ulimit
          ulimit -n ${toString cfg.openFilesLimit}
        '';
      };
    };
  };

}
