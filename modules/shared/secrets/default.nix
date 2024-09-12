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
  ban = {
    mode = "0000";
    owner = "root";
  };
  onlyBeneficiary = name: {
    mode = "0500";
    owner = name;
  };

  # type
  secretType = types.submodule (
    { name, ... }:
    {
      options = with types; {
        name = mkOption {
          type = str;
          default = name;
        };
        beneficiary = mkOption {
          type = nullOr str;
          default = "root";
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
      // (if item.beneficiary == null then ban else (onlyBeneficiary item.beneficiary))
    );

  toSharedSecret =
    item:
    nameValuePair "${item.programName}-${item.name}" (
      {
        file = "${hosts-secrets}/shared/${item.programName}/${item.name}.age";
      }
      // (if item.beneficiary == null then ban else (onlyBeneficiary item.beneficiary))
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
                inherit (item) name beneficiary;
              }) value.configFiles
            )
          ))
        ) cfg.shared;
      in
      hosts-config // shared-config;
  };

}
