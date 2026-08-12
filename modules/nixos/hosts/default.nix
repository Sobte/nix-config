{
  lib,
  config,
  namespace,
  inputs,
  ...
}:
let
  cfg = config.${namespace}.hosts;
in
{
  options.${namespace}.hosts = with lib.types; {
    enable = lib.mkEnableOption "machine hosts (/etc/hosts)";
    # Machine-name → IP mappings (`networking.hosts` shape: IP → hostnames),
    # derived from hosts-secrets keys.
    entries = lib.mkOption {
      type = attrsOf (listOf str);
      default = inputs.hosts-secrets.lib.settings.hosts;
      description = ''
        Hostname-to-IP mappings written to `/etc/hosts`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.hosts = cfg.entries;
  };
}
