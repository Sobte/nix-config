{ host, ... }:
{
  imports = [
    ./packages/core/services/fonts.nix
    ./packages/core/services/nix.nix
    ./packages/core/app/shell/zsh
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${host.username}.imports = [
      ./packages/core/app/dev-kit/nix-stuff-home.nix
      ./packages/core/app/shell/atuin/home.nix
      ./packages/core/app/shell/direnv/home.nix
      ./packages/core/app/shell/starship/home.nix
      ./packages/core/app/shell/zsh/home.nix
      ./packages/core/app/useful-cli/home.nix
      ./packages/core/app/git-home.nix
      ./packages/core/app/gnupg-home.nix
      ./packages/core/app/home-manager-home.nix
      ./packages/core/app/http-utils-home.nix
      ./packages/core/app/monitoring-home.nix
      ./packages/core/app/nix-index-home.nix
    ];
  };
}
