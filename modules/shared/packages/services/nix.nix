{ pkgs, host, ... }:
{
  nix = {
    package = pkgs.nix;

    settings = {
      # enable flakes support
      experimental-features = "nix-command flakes";

      # trusted user for nix substituters
      trusted-users = [ "${host.username}" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}
