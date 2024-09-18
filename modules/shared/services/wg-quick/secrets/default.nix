{
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
    concatMapAttrs
    foldl'
    ;
  inherit (lib.${namespace}) mkMappingOption;
  inherit (config.age) secrets;

  cfgParent = config.${namespace}.shared.services.wg-quick;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.shared.services.wg-quick.secrets = with types; {
    enable = lib.mkEnableOption "wg-quick" // {
      # If wg-quick is started, secrets are enabled by default
      default = cfgParent.enable;
    };
    useSymlinkToEtc = lib.mkEnableOption "use symlink to etc" // {
      default = true;
    };
    configNames = mkOption {
      type = listOf str;
      default = cfgParent.configNames;
    };
    files = foldl' (
      acc: name:
      acc
      // {
        ${name} = mkMappingOption rec {
          source = "wireguard/${name}.conf";
          target = secrets."${host}/${source}".path;
        };
      }
    ) { } cfg.configNames;
    owner = mkOption {
      type = str;
      default = "root";
      description = "The owner of the files.";
    };
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.shared.secrets.hosts.configFile = concatMapAttrs (_: value: {
      "${value.source}".beneficiary = cfg.owner;
    }) cfg.files;

    # etc configuration path: `/etc/wireguard`
    environment.etc = lib.mkIf cfg.useSymlinkToEtc (
      concatMapAttrs (name: value: {
        "wireguard/${name}.conf" = {
          source = value.target;
        };
      }) cfg.files
    );
  };
}
