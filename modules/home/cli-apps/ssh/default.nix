{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:
let
  inherit (config.snowfallorg.user) name;

  cfg = config.${namespace}.cli-apps.ssh;
  known_hosts = pkgs.writeText "known_hosts" ''
    UserKnownHostsFile ~/.ssh/known_hosts ${
      config.cattery.secrets.shared.users.${name}.files."ssh/known_hosts".path
    }
  '';
in
{
  options.${namespace}.cli-apps.ssh = {
    homeBlock.enable = lib.mkEnableOption "ssh home block";
  };

  config = lib.mkIf cfg.homeBlock.enable {
    cattery = {
      secrets = {
        shared.users.${name}.files = {
          "ssh/known_hosts" = { };
        };
      };
      cli-apps = {
        ssh = {
          enable = true;
          includes = [
            "${known_hosts}"
          ];
          includeNames = [
            "block_config"
          ];
        };
      };
    };
  };
}
