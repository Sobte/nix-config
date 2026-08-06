{
  imports = [
    ./deploy.nix
  ];

  cattery = {
    room.server.nas.enable = true;
    system.impermanence.enable = true;
  };

  # home block
  lovelycat = {
    cli-apps.ssh.homeBlock.enable = true;
  };
}
