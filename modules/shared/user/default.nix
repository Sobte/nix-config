{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkOption types optionalAttrs;
  inherit (lib.${namespace}) host;

  # This option is special, it does not have the `shared` prefix
  cfg = config.${namespace}.user;
in
{
  options.${namespace}.user = with types; {
    name = mkOption {
      type = str;
      default = host.name;
    };
    nickname = mkOption {
      type = nullOr str;
      default = host.nickname or cfg.name;
    };
    email = mkOption {
      type = nullOr str;
      default = host.email or null;
    };
    authorizedKeys = {
      keys = lib.mkOption {
        type = listOf singleLineStr;
        default = host.authorizedKeys.keys;
      };
      keyFiles = lib.mkOption {
        type = listOf path;
        default = [ ];
      };
    };
  };

  config =
    {
      users.users.${cfg.name} = {
        openssh.authorizedKeys = cfg.authorizedKeys;
      };
    }
    // (optionalAttrs isLinux {
      # disable automatic creation. enabling it will mess up my configuration.
      snowfallorg.users.${cfg.name}.create = false;
      users = {
        users.${cfg.name} = lib.optionalAttrs (cfg.name != "root") {
          isNormalUser = true;

          group = "users";
          # single user
          uid = 1000;
          home = "/home/${cfg.name}";

          # for sudo
          extraGroups = [ "wheel" ];
        };
        # default shell
      } // (optionalAttrs config.programs.zsh.enable { defaultUserShell = pkgs.zsh; });
    });
}
