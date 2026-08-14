{
  inputs,
  host,
  namespace,
  catteryNs,
  ...
}:
{
  imports = [ ./hardware.nix ];

  ${namespace} = {
    containerLxc.enable = true;
    # ports
    firewall.ports = [ 58755 ];
  };

  ${catteryNs} = {
    services.wg-quick.configNames =
      inputs.hosts-secrets.lib.settings.wireguard.configNames.${host} or [ ];
    system.boot.kernel.useIpForward = true;
  };

}
