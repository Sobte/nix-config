{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.fileSystems.home-nas;

  # TODO use hosts-secrets (garnix no cache secrets)
  homeUser = config.users.users.${config.${namespace}.user.name};
  homeDir = homeUser.home;
  smb-secrets = "${homeDir}/.config/hosts-secrets/shared/samba/smb-secrets";
  # By default, CIFS shares are mounted as root. If mounting as user is desirable, `uid`, `gid` and usergroup arguments can be provided as part of the filesystem options:
  uid = toString (homeUser.uid or 1000);
  gid = toString (config.groups.${homeUser.group}.gid or 100);
  # this line prevents hanging on network split
  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
in
{
  options.${namespace}.system.fileSystems.home-nas = {
    enable = lib.mkEnableOption "home nas";
  };

  config = lib.mkIf cfg.enable {
    # packages installed in system profile. to search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages = with pkgs; [ cifs-utils ];

    fileSystems."/mnt/home-shared" = {
      device = "//home.nas.oop.icu/home-shared";
      fsType = "cifs";
      options = [ "${automount_opts},credentials=${smb-secrets},uid=${uid},gid=${gid}" ];
    };

    fileSystems."/mnt/home-resources" = {
      device = "//home.nas.oop.icu/home-resources";
      fsType = "cifs";
      options = [ "${automount_opts},credentials=${smb-secrets},uid=${uid},gid=${gid}" ];
    };
  };
}
