{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/linux/core/services/samba.nix
    ../../modules/linux/desktop/configuration.nix
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  ];

  # wg-quick configuration
  networking.wg-quick.interfaces = let
    wg-conf-file = "${inputs.hosts-secrets}/hosts/home-code-nixos/wg-quick.toml";
  in
    builtins.fromTOML (builtins.readFile wg-conf-file);

  services.openssh.enable = true;
}
