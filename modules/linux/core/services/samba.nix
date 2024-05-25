{
  config,
  pkgs,
  inputs,
  ...
}: let
  # TODO use hosts-secrets (garnix no cache secrets)
  homeDir = config.users.users.meow.home;
  smb-secrets = "${homeDir}/.config/hosts-secrets/shared/samba/smb-secrets";
  # By default, CIFS shares are mounted as root. If mounting as user is desirable, `uid`, `gid` and usergroup arguments can be provided as part of the filesystem options:
  uid = "1000";
  gid = "100";
  # this line prevents hanging on network split
  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
in {
  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  fileSystems."/mnt/home-shared" = {
    device = "//home.nas.oop.icu/home-shared";
    fsType = "cifs";
    options = ["${automount_opts},credentials=${smb-secrets},uid=${uid},gid=${gid}"];
  };

  fileSystems."/mnt/home-resources" = {
    device = "//home.nas.oop.icu/home-resources";
    fsType = "cifs";
    options = ["${automount_opts},credentials=${smb-secrets},uid=${uid},gid=${gid}"];
  };
}
