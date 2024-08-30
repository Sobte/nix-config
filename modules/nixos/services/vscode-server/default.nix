{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.vscode-server;
in
{
  options.${namespace}.services.vscode-server = {
    enable = lib.mkEnableOption "vscode server";
  };

  config = lib.mkIf cfg.enable { services.vscode-server.enable = true; };

}
