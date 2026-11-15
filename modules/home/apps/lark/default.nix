{
  config,
  lib,
  pkgs,
  namespace,
  catteryNs,
  ...
}:
let
  cfg = config.${namespace}.apps.lark;

  # The ByteRTC paths are shared with the Feishu module. Only add them when
  # Feishu is not already persisting them, to avoid duplicate persistence
  # entries.
  feishuEnabled = config.${catteryNs}.apps.instant-messengers.enable or false;
in
{
  options.${namespace}.apps.lark = {
    enable = lib.mkEnableOption "Lark";
    persistence = lib.mkEnableOption "add Lark data to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.lark ];

    ${catteryNs}.system.impermanence = lib.mkIf cfg.persistence {
      directories = lib.optionals (!feishuEnabled) [
        # Lark / Feishu shared ByteRTC data
        ".bytertc"
      ];
      xdg = {
        cache.directories = [
          # Contains Electron/Chromium caches and, importantly,
          # security/com.bytedance.device_cryptographic_key.lark which is
          # required to decrypt the persisted login state.
          "LarkInternational"
        ];
        config.directories = [
          # Lark user data: login state, sdk_storage, settings, logs.
          "LarkInternational"
        ]
        ++ lib.optionals (!feishuEnabled) [
          # Lark / Feishu shared ByteRTC persistent cache.
          "bytertc"
        ];
      };
    };
  };
}
