{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (lib.${namespace}) host;

  cfg = config.${namespace}.user;
in
{
  options.${namespace}.user = {
    name = mkOption {
      type = types.str;
      default = host.name;
    };
  };

  config = {
    # disable automatic creation. enabling it will mess up my configuration.
    snowfallorg.users.${cfg.name}.create = false;
    users.users.${cfg.name} = lib.mkIf (cfg.name != "root") {
      isNormalUser = true;

      group = "users";
      # single user
      uid = 1000;
      home = "/home/${cfg.name}";

      # for sudo
      extraGroups = [ "wheel" ];
    };

    # default shell
    users.defaultUserShell = pkgs.zsh;
  };
}
