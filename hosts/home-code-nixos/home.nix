{config, ...}: {
  imports = [
    ../../modules/linux/desktop/home.nix
    ../../modules/linux/desktop/app/dev-app.nix
    ../../modules/linux/desktop/app/remote-app.nix
  ];
}
