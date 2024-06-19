{ host, ... }:
{
  imports = [ ./base.nix ];

  home-manager = {
    users.${host.username}.imports =
      [
        ./packages/app/cloud-home.nix
        ./packages/app/kubernetes-home.nix
        ./packages/app/thefuck-home.nix
        ./packages/app/visual-home.nix
        ./packages/app/youtube-dl-home.nix
      ]
      ++ (host.lib.findNixPaths ./packages/app/database)
      ++ (host.lib.findNixPaths ./packages/app/dev-kit);
  };
}
