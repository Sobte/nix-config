{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) mkOption types concatMapAttrs;
  inherit (lib.${namespace}) mkMappingOption;
  inherit (config.age) secrets;

  cfgParent = config.${namespace}.system.fileSystems.samba;
  cfg = cfgParent.secrets;

  onlyOwner = {
    inherit (config.users.users.${cfg.owner}) uid;
    # Read-only
    mode = "0400";
  };
in
{
  options.${namespace}.system.fileSystems.samba.secrets = with types; {
    enable = lib.mkEnableOption "samba" // {
      # If samba is started, secrets are enabled by default
      default = cfgParent.enable && config.${namespace}.shared.secrets.enable;
    };
    etc = {
      enable = lib.mkEnableOption "bind to etc" // {
        default = true;
      };
      useSymlink = lib.mkEnableOption "use symlink to etc" // {
        default = isDarwin || (onlyOwner.uid == null);
      };
      dirPath = mkOption {
        type = str;
        default = "samba/secrets";
        description = ''
          relative to the path of etc.
          Just like: `/etc/{etc.dirPath}`
        '';
      };
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

    # etc configuration default path: `/etc/samba/secrets`
    environment.etc = lib.mkIf cfg.etc.enable (
      concatMapAttrs (name: value: {
        "${cfg.etc.dirPath}/${name}.conf" = {
          source = value.target;
        } // (lib.optionalAttrs (!cfg.etc.useSymlink) onlyOwner);
      }) cfg.files
    );
  };
}
