{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types concatMapAttrs;
  inherit (lib.${namespace}) mkMappingOption;
  inherit (config.age) secrets;

  cfgParent = config.${namespace}.system.fileSystems.samba;
  cfg = cfgParent.secrets;
in
{
  options.${namespace}.system.fileSystems.samba.secrets = with types; {
    enable = lib.mkEnableOption "samba" // {
      # If samba is started, secrets are enabled by default
      default = cfgParent.enable && config.${namespace}.shared.secrets.enable;
    };
    useSymlinkToEtc = lib.mkEnableOption "use symlink to etc" // {
      default = true;
    };
    files = concatMapAttrs (name: _: {
      ${name} = mkMappingOption rec {
        source = "${name}.conf";
        target = secrets."samba/${source}".path;
      };
    }) cfgParent.client;
    owner = mkOption {
      type = str;
      default = "root";
      description = "The owner of the files.";
    };
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.shared.secrets.shared.samba.configFile = concatMapAttrs (_: value: {
      "${value.source}".beneficiary = cfg.owner;
    }) cfg.files;

    # etc configuration path: `/etc/samba/secrets`
    environment.etc = lib.mkIf cfg.useSymlinkToEtc (
      concatMapAttrs (name: value: {
        "samba/secrets/${name}.conf" = {
          source = value.target;
        };
      }) cfg.files
    );
  };
}
