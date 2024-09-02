{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.basis;
in
{
  options.${namespace}.room.basis = {
    enable = lib.mkEnableOption "room basis";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      cli-apps = {

        dev-kit = {
          git = mkDefaultEnabled;
          nix = mkDefaultEnabled;
        };

        nix = {
          home-manager = mkDefaultEnabled;
          nix-index = mkDefaultEnabled;
        };

        security = {
          gnupg = mkDefaultEnabled;
        };

        shell = {
          atuin = mkDefaultEnabled;
          direnv = mkDefaultEnabled;
          starship = mkDefaultEnabled;
          zsh = mkDefaultEnabled;
          # darwin config
          powershell = mkDefaultEnabled;
        };

        tool = {
          http-utils = mkDefaultEnabled;
          monitoring = mkDefaultEnabled;
          network = mkDefaultEnabled;
          compressor = mkDefaultEnabled;
          useful = mkDefaultEnabled;
        };

        # linux config
        disk = mkDefaultEnabled;
        git-credentials = mkDefaultEnabled;
        misc = mkDefaultEnabled;
      };
    };
  };
}
