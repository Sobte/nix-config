{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib)
    mkOption
    types
    concatMapAttrs
    foldl'
    ;
  inherit (lib.${namespace}) mkMappingOption;
  inherit (config.age) secrets;

  cfgParent = config.${namespace}.services.cloudflared;
  cfg = cfgParent.secrets;

  onlyOwner = {
    inherit (config.users.users.${cfg.owner}) uid;
    # Read-only
    mode = "0400";
  };
  group = "cloudflared";
in
{
  options.${namespace}.services.cloudflared.secrets = with types; {
    enable = lib.mkEnableOption "cloudflared" // {
      # If cloudflared is started, secrets are enabled by default
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
        default = "cloudflared/credentials";
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
          names = builtins.attrNames cfgParent.tunnels;
        in
        foldl' (
          acc: name:
          acc
          ++ [
            "${name}"
          ]
        ) [ ] names;
    };
    files = foldl' (
      acc: name:
      acc
      // {
        ${name} = mkMappingOption rec {
          source = "credentials/${name}.json";
          target = secrets."cloudflared/${source}".path;
        };
      }
    ) { } cfg.configNames;
    owner = mkOption {
      type = str;
      default = "cloudflared";
      description = "The owner of the files.";
    };
    createOwner = lib.mkEnableOption "auto create cloudflared owner" // {
      default = !cfgParent.enable && (config.${namespace}.user.name != cfg.owner);
    };
  };

  config = lib.mkIf cfg.enable {
    # secrets
    ${namespace}.shared.secrets.shared.cloudflared.configFile = concatMapAttrs (_: value: {
      "${value.source}".beneficiary = cfg.owner;
    }) cfg.files;

    # etc configuration default path: `/etc/cloudflared/credentials`
    environment.etc = lib.mkIf cfg.etc.enable (
      concatMapAttrs (name: value: {
        "${cfg.etc.dirPath}/${name}.json" = {
          source = value.target;
        } // (lib.optionalAttrs (!cfg.etc.useSymlink) onlyOwner);
      }) cfg.files
    );

    users = lib.mkIf cfg.createOwner {
      users.${cfg.owner} = {
        inherit group;
        name = cfg.owner;
        description = "cloudflared tunnel user";
        createHome = false;
        useDefaultShell = true;
        isSystemUser = true;
      };
      users.groups.${group} = { };
    };
  };
}
