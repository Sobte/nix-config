{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.desktop.dev;
in
{
  options.${namespace}.room.desktop.dev = {
    enable = lib.mkEnableOption "room desktop dev";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.desktop.general = mkDefaultEnabled;

      apps = {
        instant-messengers = mkDefaultEnabled;
        jetbrains = mkDefaultEnabled;
      };
      cli-apps = {

        database = {
          postgresql = mkDefaultEnabled;
          sqlite = mkDefaultEnabled;
        };

        dev-kit = {
          cpp = mkDefaultEnabled;
          dive = mkDefaultEnabled;
          go = mkDefaultEnabled;
          javascript = mkDefaultEnabled;
          lua = mkDefaultEnabled;
          rust = mkDefaultEnabled;
          wasm = mkDefaultEnabled;
        };

        operations = {
          cloud = mkDefaultEnabled;
          kubernetes = mkDefaultEnabled;
        };

        tool = {
          ollama = mkDefaultEnabled;
          thefuck = mkDefaultEnabled;
        };

        video = {
          visual = mkDefaultEnabled;
          youtube = mkDefaultEnabled;
        };
      };

      # linux config
      apps = {
        mail = mkDefaultEnabled;
        safety = mkDefaultEnabled;
        science = mkDefaultEnabled;
        video = mkDefaultEnabled;
      };
      cli-apps = {
        cloudflared = mkDefaultEnabled;
        tailscale = mkDefaultEnabled;
        warp = mkDefaultEnabled;
      };

      # darwin config
      apps = {
        iina = mkDefaultEnabled;
      };
      cli-apps = {
        android = mkDefaultEnabled;
      };

    };
  };
}
