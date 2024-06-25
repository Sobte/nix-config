{ host, ... }:
{
  imports = [ ./base.nix ];

  home-manager = {
    users.${host.username}.imports = [ ./packages/app/acme-sh-home.nix ];
  };
}
