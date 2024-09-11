{
  pkgs,
  inputs,
  host,
  system,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib)
    mkOption
    mkEnableOption
    optional
    optionalAttrs
    types
    nameValuePair
    concatMapAttrs
    ;

  cfg = config.${namespace}.shared.secrets;

  # user home
  userName = config.${namespace}.user.name;
  homeUser = config.users.users.${userName};
  homeDir = homeUser.home;

  # secrets path
  hosts-secrets = "${homeDir}/.config/hosts-secrets";

  # permissions
  onlyRoot = {
    mode = "0500";
    owner = "root";
  };
  onlyUser = {
    mode = "0500";
    owner = userName;
  };

  # type
  secretType = types.submodule (
    { name, ... }:
    {
      options = {
        name = mkOption {
          type = types.str;
          default = name;
        };
        onlyRoot = mkEnableOption "Only root privileges, If disabled, enable onlyUser." // {
          default = true;
        };
      };
    }
  );

  # secrets object
  toHostSecret =
    item:
    nameValuePair "${host}-${item.name}" (
      {
        file = "${hosts-secrets}/hosts/${host}/${item.name}.age";
      }
      // (if item.onlyRoot then onlyRoot else onlyUser)
    );

  toSharedSecret =
    item:
    nameValuePair "${item.programName}-${item.name}" (
      {
        file = "${hosts-secrets}/shared/${item.programName}/${item.name}.age";
      }
      // (if item.onlyRoot then onlyRoot else onlyUser)
    );
in
{
  options.${namespace}.shared.secrets = with types; {
    enable = mkEnableOption "secrets";
    yubikey.enable = mkEnableOption "yubikey support";
    # hosts private config
    hosts.configFiles = mkOption {
      type = listOf secretType;
      default = [ ];
    };
    # shared config
    shared = mkOption {
      type = attrsOf (submodule {
        options.configFiles = mkOption {
          type = listOf secretType;
          default = [ ];
        };
      });
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    # agenix cli
    environment.systemPackages = [
      (inputs.agenix.packages.${system}.default.override {
        plugins = optional cfg.yubikey.enable pkgs.age-plugin-yubikey;
      })
    ];
    services = optionalAttrs (cfg.yubikey.enable && isLinux) {
      pcscd.enable = true;
    };

    # secrets
    age.secrets =
      let
        hosts-config = builtins.listToAttrs (map toHostSecret cfg.hosts.configFiles);
        shared-config = concatMapAttrs (
          name: value:
          (builtins.listToAttrs (
            map toSharedSecret (
              map (item: {
                programName = name;
                inherit (item) name onlyRoot;
              }) value.configFiles
            )
          ))
        ) cfg.shared;
      in
      hosts-config // shared-config;
  };

}
