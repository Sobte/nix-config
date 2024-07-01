{ inputs, ... }:
{
  imports = [ ../../modules/darwin/configuration.nix ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];

  environment.etc = {
    # wg-quick configuration
    "wireguard/wg-go-home.conf" = {
      source = "${inputs.hosts-secrets}/hosts/home-code-mbp/wg-go-home.conf";
    };
    # sing-box configuration
    "sing-box/config.json" = {
      source = "${inputs.hosts-secrets}/shared/sing-box/config.json";
    };
  };
}
