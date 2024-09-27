{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkDefaultEnabled;

  cfg = config.${namespace}.room.server;
in
{
  options.${namespace}.room.server = {
    enable = lib.mkEnableOption "room server";
  };

  config = lib.mkIf cfg.enable {
    ${namespace} = {
      room.general = mkDefaultEnabled;

      services = {
        acme = mkDefaultEnabled;
      };
    };
  };
}
