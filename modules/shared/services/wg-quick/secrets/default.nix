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
      default = cfgParent.enable && config.${namespace}.shared.secrets.enable;
    };
    useSymlinkToEtc = lib.mkEnableOption "use symlink to etc" // {
      default = true;
    };
    dirPathInEtc = mkOption {
      type = str;
      default = "wireguard";
      description = ''
        Symlink is in the etc folder, relative to the path of etc.
        Just like: `/etc/{dirPathInEtc}`
      '';
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

    # etc configuration default path: `/etc/wireguard`
    environment.etc = lib.mkIf cfg.useSymlinkToEtc (
      concatMapAttrs (name: value: {
        "${cfg.dirPathInEtc}/${name}.conf" = {
          source = value.target;
        };
      }) cfg.files
    );
  };
}
