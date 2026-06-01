{ lib, namespace, ... }:
{
  imports = [
    ./disk.nix
  ];

  cattery = {
    user = {
      name = "root"; # use root as default user
      authorizedKeys = {
        keys = [
          # This is the default key for root user
          ""
        ]
        ++ (lib.${namespace}.host.authorizedKeys.keys or [ ]);
      };
    };
    room.server-mini.enable = true;
    # Enable EFI boot support
    system.boot.efi.enable = true;
  };

  system.stateVersion = "26.11";
}
