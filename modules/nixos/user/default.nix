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
    users.users.${cfg.name} = {
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
