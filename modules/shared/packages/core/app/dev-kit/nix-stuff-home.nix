{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # nix stuff
      alejandra
      nixfmt-rfc-style # An opinionated formatter for Nix
      nil # nix language server
    ];
  };
}
