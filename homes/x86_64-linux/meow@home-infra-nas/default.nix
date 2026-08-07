{ namespace, catteryNs, ... }:
{
  imports = [
    ./deploy.nix
  ];

  ${catteryNs} = {
    room.server.nas.enable = true;
    system.impermanence.enable = true;
  };

  # home block
  ${namespace} = {
    cli-apps.ssh.homeBlock.enable = true;
  };
}
