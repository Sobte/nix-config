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

  # By default, CIFS shares are mounted as root. 
  # If mounting as user is desirable, `uid`, `gid` 
  # and usergroup arguments can be provided as part of the filesystem options:
  inherit (config.${namespace}.user) uid gid;

  cfg = config.${namespace}.system.fileSystems.samba;

  # type
  sambaType = types.submodule (
    { name, ... }:
    {
      options = with types; {
        hostUrl = mkOption {
          type = str;
          default = "";
        };
        binds = mkOption {
          type = attrsOf (bindType name);
          default = { };
        };
      };
    }
  );
  bindType =
    sambaName:
    types.submodule {
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
          type = path;
          default = "/etc/samba/secrets/${sambaName}.conf";
        };
        extraOptions = mkOption {
          type = listOf str;
          default = [ ];
        };
      };
    };

  # object
  toFileSystem =
    _: value:
    (mapAttrs' (
      name2: value2:
      nameValuePair "/mnt/${name2}" {
        device = "//${value.hostUrl}/${name2}";
        fsType = "cifs";
        options = [
          "${value2.autoMountOpts},credentials=${value2.secretsPath},uid=${toString value2.uid},gid=${toString value2.gid}"
        ] ++ value2.extraOptions;
      }
    ) value.binds);
in
{
  options.${namespace}.system.fileSystems.samba = with types; {
    enable = lib.mkEnableOption "samba client";
    client = mkOption {
      type = attrsOf sambaType;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ cifs-utils ];

    fileSystems = mergeAttrsList (mapAttrsToList toFileSystem cfg.client);
  };
}
