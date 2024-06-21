{
  imports = [
    ../../modules/linux/server.nix
    # home samba
    ../../modules/linux/packages/core/services/samba.nix
    # vscode server
    ../../modules/linux/packages/core/services/vscode-server.nix
  ];

  # packages installed in system profile. to search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];
}
