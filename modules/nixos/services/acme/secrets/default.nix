{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib.${namespace}) getRootDomain;
  inherit (lib)
    optionalString
    mkOption
    types
    concatMapAttrs
    foldl'
    unique
    ;
  inherit (lib.${namespace}) mkMappingOption;
  inherit (config.age) secrets;

  cfgParent = config.${namespace}.services.acme;
  cfg = cfgParent.secrets;

  onlyOwner = {
    inherit (config.users.users.${cfg.owner}) uid;
    # Read-only
    mode = "0400";
  };
  group = "acme";
in
{
  options.${namespace}.services.acme.secrets = with types; {
    enable = lib.mkEnableOption "acme" // {
      # If acme is started, secrets are enabled by default
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
        default = "acme/env";
        description = ''
          relative to the path of etc.
          Just like: `/etc/{etc.dirPath}`
        '';
      };
    };
    configNames = mkOption {
      type = listOf str;
      default =
        let
          names = builtins.attrNames cfgParent.certs;
        in
        unique (
          foldl' (
            acc: name:
            acc
            ++ [
              "${optionalString ((cfgParent.certs.${name}.environmentFile or null) == null) (getRootDomain name)}"
            ]
          ) [ ] names
        );
    };
    files = foldl' (
      acc: name:
      acc
      // {
        ${name} = mkMappingOption rec {
          source = "env/${name}.env";
          target = secrets."acme/${source}".path;
        };
      }
    ) { } cfg.configNames;
    owner = mkOption {
      type = str;
      default = "acme";
      description = "The owner of the files.";
    };
    createOwner = lib.mkEnableOption "auto create acme owner" // {
      default = !cfgParent.enable && (config.${namespace}.user.name != cfg.owner);
    };
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.shared.secrets.shared.acme.configFile = concatMapAttrs (_: value: {
      "${value.source}".beneficiary = cfg.owner;
    }) cfg.files;

    # etc configuration default path: `/etc/acme/env`
    environment.etc = lib.mkIf cfg.etc.enable (
      concatMapAttrs (name: value: {
        "${cfg.etc.dirPath}/${name}.env" = {
          source = value.target;
        } // (lib.optionalAttrs (!cfg.etc.useSymlink) onlyOwner);
      }) cfg.files
    );

    users = lib.mkIf cfg.createOwner {
      users.${cfg.owner} = {
        inherit group;
        name = cfg.owner;
        description = "acme web server user";
        createHome = false;
        useDefaultShell = true;
      };
      users.groups.${group} = { };
    };
  };
}
