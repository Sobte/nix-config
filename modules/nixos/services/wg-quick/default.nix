{
  pkgs,
  config,
  lib,
  namespace,
  host,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    nameValuePair
    foldl'
    ;

  cfg = config.${namespace}.services.wg-quick;
in
{
  options.${namespace}.services.wg-quick = with types; {
    enable = lib.mkEnableOption "wireguard wg-quick";
    configNames = mkOption {
      type = listOf str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wireguard-tools ];
    # secrets
    ${namespace}.shared.secrets.hosts.configFiles = foldl' (
      acc: name:
      acc
      // {
        "${name}.conf".beneficiary = "root";
      }
    ) { } cfg.configNames;
    # wg-quick configuration
    networking.wg-quick.interfaces = builtins.listToAttrs (
      map (
        name:
        nameValuePair name {
          configFile = config.age.secrets."${host}/${name}.conf".path;
        }
      ) cfg.configNames
    );
  };
}
