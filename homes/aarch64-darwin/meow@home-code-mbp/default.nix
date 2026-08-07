{ namespace, catteryNs, ... }:
{
  ${catteryNs}.room.desktop.dev = {
    enable = true;
  };

  # home block
  ${namespace} = {
    cli-apps.ssh.homeBlock.enable = true;
  };
}
