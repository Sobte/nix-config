{ pkgs, host, ... }:
{
  imports = [
    ./packages/services/fonts.nix
    ./packages/services/nix.nix
    ./packages/app/shell/zsh
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${host.username}.imports = [
      ./packages/app/dev-kit/nix-stuff-home.nix
      ./packages/app/shell/atuin/home.nix
      ./packages/app/shell/direnv/home.nix
      ./packages/app/shell/starship/home.nix
      ./packages/app/shell/zsh/home.nix
      ./packages/app/useful-cli/home.nix
      ./packages/app/git-home.nix
      ./packages/app/gnupg-home.nix
      ./packages/app/home-manager-home.nix
      ./packages/app/http-utils-home.nix
      ./packages/app/monitoring-home.nix
      ./packages/app/nix-index-home.nix
    ];
  };

  users.defaultUserShell = pkgs.zsh;
}
