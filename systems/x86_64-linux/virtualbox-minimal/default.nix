{ catteryNs, ... }:
{
  ${catteryNs} = {
    user.name = "root"; # use nixos as default user
    room.server = {
      enable = true;
      cloud-init = {
        enable = true;
      };
    };
    system.boot.efi.enable = false;
  };

  nixpkgs.overlays = [
    (final: _prev: {
      linuxPackages = final.linuxPackages_latest;
    })
  ];

  system.stateVersion = "26.11";
}
