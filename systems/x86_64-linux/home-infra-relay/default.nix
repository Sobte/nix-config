{ namespace, ... }:
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    user.name = "root"; # use root as default user
    room.server.enable = true;
    services.getty.enable = true;
    shared.services.sing-box = {
      enable = true;
    };
    system.boot.kernel.useIpForward = true;
  };

  # close firewall
  networking.firewall.enable = false;

  system.stateVersion = "24.11";
}
