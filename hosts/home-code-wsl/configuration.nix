{ pkgs, inputs, ... }:
{
  imports = [
    # include NixOS-WSL modules
    # <nixos-wsl/modules>
    ../../modules/linux/core/services/samba.nix
    ../../modules/linux/desktop/configuration.nix
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ ];
}
