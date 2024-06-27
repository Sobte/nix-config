{
  imports = [
    ./base.nix

    ../shared/server.nix
    # efi boot
    ./packages/core/boot/loader/efi.nix
    # docker
    ./packages/core/services/docker.nix
  ];
}
