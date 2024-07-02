{ inputs, ... }:
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  programs = {
    # command not found in nix
    nix-index.enable = true;
  };
}
