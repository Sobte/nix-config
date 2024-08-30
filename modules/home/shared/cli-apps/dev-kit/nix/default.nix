{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.dev-kit.nix;
in
{
  options.${namespace}.cli-apps.dev-kit.nix = {
    enable = lib.mkEnableOption "nix";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # nix stuff
      alejandra
      nixfmt-rfc-style # An opinionated formatter for Nix
      nil # nix language server
    ];
  };

}
