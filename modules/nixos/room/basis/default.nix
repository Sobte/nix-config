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
        openssh = mkDefaultEnabled;
      };

      system = {
        locale = mkDefaultEnabled;
        network = mkDefaultEnabled;
        time = mkDefaultEnabled;
        kernel-latest = mkDefaultEnabled;
      };

      # shared
      shared = {
        nix = mkDefaultEnabled;
        secrets = mkDefaultEnabled;
        cli-apps = {
          shell.zsh = mkDefaultEnabled;
          security.fido2 = mkDefaultEnabled;
        };
        services.openssh = mkDefaultEnabled;
        system = {
          ulimit = mkDefaultEnabled;
        };
      };
    };

  };
}
