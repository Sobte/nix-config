{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.system.fileSystems.home-nas;

  # secrets path
  secrets = config.age.secrets."samba-home-nas.conf".path;
  # home user
  homeUser = config.users.users.${config.${namespace}.user.name};
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
    # enable secrets
    ${namespace}.shared.secrets.shared.samba.configFiles = [ { name = "home-nas.conf"; } ];

    environment.systemPackages = with pkgs; [ cifs-utils ];

    fileSystems."/mnt/home-shared" = {
      device = "//home.nas.oop.icu/home-shared";
      fsType = "cifs";
      options = [ "${automount_opts},credentials=${secrets},uid=${uid},gid=${gid}" ];
    };

    fileSystems."/mnt/home-resources" = {
      device = "//home.nas.oop.icu/home-resources";
      fsType = "cifs";
      options = [ "${automount_opts},credentials=${secrets},uid=${uid},gid=${gid}" ];
    };
  };
}
