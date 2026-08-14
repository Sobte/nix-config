{
  inputs,
  host,
  catteryNs,
  ...
}:
{
  imports = with inputs; [
    nixos-hardware.nixosModules.friendlyarm-nanopi-r5s
  ];

  ${catteryNs} = {
    user.name = "root"; # use root as default user
    room.server.enable = true;
    system.boot.efi.enable = false;
    services.wg-quick.configNames =
      inputs.hosts-secrets.lib.settings.wireguard.configNames.${host} or [ ];
  };

}
