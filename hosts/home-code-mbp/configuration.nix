{ inputs, ... }:
{
  imports = [ ../../modules/darwin/configuration.nix ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];

  # wg-quick configuration
  environment.etc = {
    "wireguard/wg-go-home.conf" = {
      source = "${inputs.hosts-secrets}/hosts/home-code-mbp/wg-go-home.conf";
    };
  };
}
