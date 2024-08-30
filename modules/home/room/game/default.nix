{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.game;
in
{
  options.${namespace}.room.game = {
    enable = lib.mkEnableOption "room game";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.basis = mkDefaultEnabled;

      apps = {
        vscode = mkDefaultEnabled;
        instant-messengers = mkDefaultEnabled;
      };
      cli-apps = {
        video = {
          visual = mkDefaultEnabled;
          youtube = mkDefaultEnabled;
        };
      };

      # linux config
      apps = {
        game = mkDefaultEnabled;
      };

      # darwin config
      apps = {
        iina = mkDefaultEnabled;
      };

    };
  };
}
