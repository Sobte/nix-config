{
  imports = [
    ./hardware.nix
    ./timers.nix
  ];

  cattery = {
    user.name = "root"; # use root as default user
    room.server.enable = true;
    services.getty.enable = true;
    services.sing-box = {
      enable = true;
    };
    system.boot.kernel.useIpForward = true;
  };

  # close firewall
  networking.firewall.enable = false;

  system.stateVersion = "25.11";
}
