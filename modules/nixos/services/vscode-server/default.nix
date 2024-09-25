{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.${namespace}.services.vscode-server;
in
{
  options.${namespace}.services.vscode-server = with types; {
    enable = lib.mkEnableOption "vscode server";
    extraOptions = mkOption {
      type = attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.vscode-server = {
      enable = true;
    } // cfg.extraOptions;
  };

}
