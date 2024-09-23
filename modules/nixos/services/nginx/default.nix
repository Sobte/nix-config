{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.nginx;
in
{
  options.${namespace}.services.nginx = with types; {
    enable = lib.mkEnableOption "nginx";
    httpSubConfigPath = mkOption {
      type = str;
      default = "/etc/nginx/conf.d/*.conf";
      description = ''
        To make the configuration easier to maintain, we recommend that you split it into a set of 
        feature‑specific files stored in the `/etc/nginx/conf.d` directory and use the include directive in the 
        main `nginx.conf` file to reference the contents of the feature‑specific files.
      '';
    };
    commonHttpConfig = mkOption {
      type = lines;
      default = "";
    };
    httpConfig = mkOption {
      type = lines;
      default = "";
    };
    appendHttpConfig = mkOption {
      type = lines;
      default = "";
    };
    virtualHosts = mkOption {
      type = attrs;
      default = { };
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      inherit (cfg)
        enable
        httpConfig
        appendHttpConfig
        virtualHosts
        ;
      package = pkgs.nginxQuic; # use full
      commonHttpConfig = lib.mkBefore (
        ''
          include ${cfg.httpSubConfigPath};
        ''
        + cfg.commonHttpConfig
      );
    } // cfg.extraOptions;
  };
}
