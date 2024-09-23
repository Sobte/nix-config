{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (lib) mkOption types optionalAttrs;
  inherit (lib.${namespace}) host;

  linuxUserGroup = "users";
  user = config.users.users.${cfg.name};

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
    home = mkOption {
      type = nullOr str;
      default = user.home;
      readOnly = true;
    };
    uid = mkOption {
      type = nullOr int;
      default = user.uid;
      readOnly = true;
    };
    gid = mkOption {
      type = nullOr int;
      default = if isLinux then config.users.groups.${linuxUserGroup}.gid else user.gid;
      readOnly = true;
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
      users.users.${cfg.name} =
        {
          openssh.authorizedKeys = cfg.authorizedKeys;
        }
        // (lib.optionalAttrs isDarwin {
          # Just to ensure that it is not null when accessing, the default value on Mac is 501
          uid = 501;
        });
    }
    // (optionalAttrs isLinux {
      # disable automatic creation. enabling it will mess up my configuration.
      snowfallorg.users.${cfg.name}.create = false;
      users = {
        users.${cfg.name} = lib.optionalAttrs (cfg.name != "root") {
          isNormalUser = true;

          group = linuxUserGroup;
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
