{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.yubikey;
in
{
  options.${namespace}.apps.yubikey = {
    enable = lib.mkEnableOption "yubikey";
  };

  config = lib.mkIf cfg.enable {
    services.yubikey-agent.enable = true;

    ${namespace}.home.extraOptions = {
      home.packages = with pkgs; [ yubikey-manager-qt ];
    };
  };

}
