{
  imports = [
    ./base.nix

    ../shared/server.nix

    ./packages/core/services/docker.nix
  ];
}
