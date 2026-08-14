{ catteryNs, ... }:
{
  imports = [
    ./hardware.nix
    ./services.nix
  ];

  ${catteryNs} = {
    user.name = "root"; # use root as default user
    room.server.enable = true;
    services.getty.enable = true;
    system.boot.efi.enable = true;
  };

}
