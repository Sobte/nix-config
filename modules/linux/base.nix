{ host, ... }:
{
  imports = [
    ../shared/base.nix

    # core services
    ./packages/core/services/gnupg.nix
    ./packages/core/services/network.nix
    ./packages/core/services/nix.nix
    ./packages/core/services/openssh.nix
  ];

  home-manager = {
    users.${host.username}.imports = [
      # core app
      ./packages/core/app/git-credentials-home.nix
      ./packages/core/app/misc-utils-home.nix
      ./packages/core/app/network-utils-home.nix
      ./packages/core/app/p7zip-home.nix
    ];
  };
}
