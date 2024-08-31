{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.basis;
in
{
  options.${namespace}.room.basis = {
    enable = lib.mkEnableOption "room basis";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      nix = mkDefaultEnabled;

      cli-apps = {
        nix = {
          nix-ld = mkDefaultEnabled;
        };
      };

      services = {
        cron = mkDefaultEnabled;
        gnupg = mkDefaultEnabled;
        network = mkDefaultEnabled;
        openssh = mkDefaultEnabled;
      };

      system = {
        locale = mkDefaultEnabled;
        time = mkDefaultEnabled;
      };

      # shared
      shared = {
        nix = mkDefaultEnabled;
        cli-apps.shell.zsh = mkDefaultEnabled;
        system = {
          fonts = mkDefaultEnabled;
          ulimit = mkDefaultEnabled;
        };
      };
    };

  };
}
