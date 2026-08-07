{ catteryNs, ... }:
{
  imports = [ ./system.nix ];

  ${catteryNs} = {
    nix.secrets.enable = true;
    room.desktop.dev.enable = true;
    services = {
      wg-quick = {
        enable = true;
        configNames = [ "wg-go-home" ];
      };
      openssh.extraConfig = ''
        StreamLocalBindUnlink yes
      '';
    };
  };

  system.stateVersion = 5;
}
