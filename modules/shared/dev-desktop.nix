{ host, ... }:
{
  imports = [ ./desktop.nix ];

  home-manager = {
    users.${host.username}.imports =
      [
        ./packages/core/app/cloud-home.nix
        ./packages/core/app/kubernetes-home.nix
        ./packages/core/app/visual-home.nix
        ./packages/core/app/youtube-dl-home.nix
        # desktop app
        ./packages/desktop/app/instant-messengers-home.nix
        ./packages/desktop/app/jetbrains-home.nix
      ]
      ++ (host.lib.findNixPaths ./packages/core/app/database)
      ++ (host.lib.findNixPaths ./packages/core/app/dev-kit);
  };
}
