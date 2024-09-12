{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    nameValuePair
    mergeAttrsList
    mapAttrsToList
    mapAttrs'
    ;

  cfg = config.${namespace}.system.fileSystems.samba;

  # home user
  homeUser = config.users.users.${config.${namespace}.user.name};
  # By default, CIFS shares are mounted as root. 
  # If mounting as user is desirable, `uid`, `gid` 
  # and usergroup arguments can be provided as part of the filesystem options:
  uid = homeUser.uid or 1000;
  gid = config.groups.${homeUser.group}.gid or 100;

  # type
  sambaType = types.submodule {
    options = with types; {
      hostUrl = mkOption {
        type = str;
        default = "";
      };
      binds = mkOption {
        type = attrsOf bindType;
        default = { };
      };
    };
  };
  bindType = types.submodule {
    options = with types; {
      uid = mkOption {
        type = int;
        default = uid;
      };
      gid = mkOption {
        type = int;
        default = gid;
      };
      autoMountOpts = mkOption {
        type = str;
        # this line prevents hanging on network split
        default = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      };
      secretsPath = mkOption {
        type = nullOr str;
        default = null;
      };
      extraOptions = mkOption {
        type = listOf str;
        default = [ ];
      };
    };
  };

  # object
  toFileSystem =
    name: value:
    (mapAttrs' (
      name2: value2:
      nameValuePair "/mnt/${name2}" {
        device = "//${value.hostUrl}/${name2}";
        fsType = "cifs";
        options = [
          "${value2.autoMountOpts},credentials=${
            if value2.secretsPath == null then
              config.age.secrets."samba/${name}.conf".path
            else
              value2.secretsPath
          },uid=${toString value2.uid},gid=${toString value2.gid}"
        ] ++ value2.extraOptions;
      }
    ) value.binds);
in
{
  options.${namespace}.system.fileSystems.samba = with types; {
    enable = lib.mkEnableOption "samba client";
    clients = mkOption {
      type = attrsOf sambaType;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ cifs-utils ];

    # enable secrets
    ${namespace}.shared.secrets.shared.samba.configFiles = mapAttrs' (
      name: _: nameValuePair "${name}.conf" { beneficiary = "root"; }
    ) cfg.clients;

    fileSystems = mergeAttrsList (mapAttrsToList toFileSystem cfg.clients);
  };
}
