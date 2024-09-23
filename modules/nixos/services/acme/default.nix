{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    concatMapAttrs
    optional
    ;
  inherit (lib.${namespace}) getRootDomain;
  inherit (config.${namespace}) user;
  inherit (config.${namespace}.services) nginx;

  cfg = config.${namespace}.services.acme;
in
{
  options.${namespace}.services.acme = with types; {
    enable = lib.mkEnableOption "acme";
    email = mkOption {
      type = nullOr str;
      default = user.email or null;
    };
    group = mkOption {
      type = str;
      default = if nginx.enable then "nginx" else "acme";
    };
    dnsProvider = mkOption {
      type = nullOr str;
      default = "cloudflare";
      description = ''
        see the “code” field of the DNS providers listed at https://go-acme.github.io/lego/dns/.
      '';
    };
    postRun = mkOption {
      type = lines;
      default = "";
    };
    reloadServices = mkOption {
      type = listOf str;
      default = optional nginx.enable "nginx.service";
    };
    certs = mkOption {
      type = attrs;
      default = { };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    security.acme = {
      defaults = {
        inherit (cfg)
          email
          group
          dnsProvider
          ;
      };
      certs = concatMapAttrs (name: value: {
        ${name} = value // {
          environmentFile =
            if (value.environmentFile or null) != null then
              value.environmentFile
            else
              "/etc/acme/env/${getRootDomain name}.env";
        };
      }) cfg.certs;
      acceptTerms = cfg.enable;
    } // cfg.extraOptions;
  };
}
