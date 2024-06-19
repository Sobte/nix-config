{
  imports = [
    ../../modules/linux/general-desktop.nix
    # gnome
    ../../modules/linux/packages/desktop/display/gnome
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];
}
