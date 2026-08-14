{ catteryNs, namespace, ... }:
{
  imports = [
    ./hardware.nix
    ./services.nix
  ];

  ${namespace}.containerLxc.enable = true;

  ${catteryNs} = { };

}
