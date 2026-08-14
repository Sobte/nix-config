{
  inputs,
  host,
  catteryNs,
  ...
}:
{
  imports = [ ./system.nix ];

  ${catteryNs} = {
    nix.secrets.enable = true;
    room.desktop.dev.enable = true;
    services = {
      wg-quick = {
        enable = true;
        configNames = inputs.hosts-secrets.lib.settings.wireguard.configNames.${host} or [ ];
      };
      openssh.extraConfig = ''
        StreamLocalBindUnlink yes
      '';
    };
  };

  system.stateVersion = 5;
}
