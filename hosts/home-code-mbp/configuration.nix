{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/darwin/configuration.nix
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  ];
}
