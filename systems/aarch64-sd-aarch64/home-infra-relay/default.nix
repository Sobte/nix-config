{ namespace, ... }:
{
  ${namespace} = {
    user.name = "root"; # use root as default user
    room.server.enable = true;
    # r5s requires a specific bootloader.
    system.boot.efi.enable = false;
    # autologin
    services.getty.enable = true;
  };

  system.stateVersion = "24.11";
}
