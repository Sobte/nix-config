{
  boot.isContainer = true;
  # remove the debugfs mount
  systemd.mounts = [
    {
      where = "/sys/kernel/debug";
      enable = false;
    }
  ];
}
