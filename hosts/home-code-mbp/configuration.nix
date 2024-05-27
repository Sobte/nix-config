{ pkgs, inputs, ... }:
{
  imports = [ ../../modules/darwin/configuration.nix ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ ];

  # wg-quick configuration
  environment.etc = {
    "wireguard/wg-go-home.conf" = {
      configFile = "${inputs.hosts-secrets}/hosts/home-code-mbp/wg-go-home.conf";
    };
  };
}
