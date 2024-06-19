{ host, ... }:
{
  imports = [ ./base.nix ];

  home-manager = {
    users.${host.username}.imports =
      (host.lib.findNixPaths ./packages/app/database)
      ++ (host.lib.findNixPaths ./packages/app/dev-kit)
      ++ (host.lib.findNixPaths ./packages/app);
  };
}
