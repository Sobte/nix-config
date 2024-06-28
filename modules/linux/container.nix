{
  imports = [
    ./base.nix

    ../shared/server.nix
    # container boot
    ./packages/core/boot/loader/container.nix
  ];
}
