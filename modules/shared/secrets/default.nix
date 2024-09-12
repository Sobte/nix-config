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
    mapAttrs'
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
  secretType = types.submodule {
    options = with types; {
      beneficiary = mkOption {
        type = nullOr str;
        default = null;
      };
    };
  };

  # secrets object
  toHostSecret =
    name: value:
    nameValuePair "${host}/${name}" (
      {
        file = "${hosts-secrets}/hosts/${host}/${name}.age";
      }
      // (if value.beneficiary == null then ban else (onlyBeneficiary value.beneficiary))
    );

  toSharedSecret =
    name: value:
    nameValuePair "${value.programName}/${name}" (
      {
        file = "${hosts-secrets}/shared/${value.programName}/${name}.age";
      }
      // (if value.beneficiary == null then ban else (onlyBeneficiary value.beneficiary))
    );
in
{
  options.${namespace}.shared.secrets = with types; {
    enable = mkEnableOption "secrets";
    yubikey.enable = mkEnableOption "yubikey support";
    # hosts private config
    hosts.configFiles = mkOption {
      type = attrsOf secretType;
      default = { };
    };
    # shared config
    shared = mkOption {
      type = attrsOf (submodule {
        options.configFiles = mkOption {
          type = attrsOf secretType;
          default = { };
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
        hosts-config = mapAttrs' toHostSecret cfg.hosts.configFiles;
        shared-config = concatMapAttrs (
          name: value:
          mapAttrs' toSharedSecret (
            mapAttrs' (
              name2: value2:
              nameValuePair name2 {
                programName = name;
                inherit (value2) beneficiary;
              }
            ) value.configFiles
          )
        ) cfg.shared;
      in
      hosts-config // shared-config;
  };

}
