{ host, ... }:
{
  imports = [ ./base.nix ];

  home-manager = {
    users.${host.username}.imports = [ ./packages/core/app/acme-sh-home.nix ];
  };
}
