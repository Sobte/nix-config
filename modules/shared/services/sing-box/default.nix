{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.shared.services.sing-box;
in
{
  options.${namespace}.shared.services.sing-box = {
    enable = lib.mkEnableOption "sing-box";
    configName = lib.mkOption {
      type = lib.types.str;
      default = "config.json";
    };
  };

  config = lib.mkIf cfg.enable (
    {
      # secrets
      ${namespace}.shared.secrets.shared.sing-box.configFiles = {
        ${cfg.configName}.beneficiary = "root";
      };
      # sing-box configuration
      environment.etc = {
        "sing-box/config.json" = {
          source = config.age.secrets."sing-box/${cfg.configName}".path;
        };
      };
    }
    // (lib.optionalAttrs isLinux {
      # enable sing-box
      services.sing-box.enable = true;
    })
  );

}
