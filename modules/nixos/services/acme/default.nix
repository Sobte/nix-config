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
    useRoot = lib.mkEnableOption ''
      Whether to use the root user when generating certs. This is not recommended
      for security + compatibility reasons. If a service requires root owned certificates
      consider following the guide on "Using ACME with services demanding root
      owned certificates" in the NixOS manual, and only using this as a fallback
      or for testing.
    '';
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
      inherit (cfg) useRoot;
      defaults = {
        inherit (cfg)
          email
          group
          dnsProvider
          ;
      };
      certs = concatMapAttrs (name: value: {
        ${name} = {
          environmentFile = "/etc/acme/env/${getRootDomain name}.env";
        } // value;
      }) cfg.certs;
      acceptTerms = cfg.enable;
    } // cfg.extraOptions;
  };
}
