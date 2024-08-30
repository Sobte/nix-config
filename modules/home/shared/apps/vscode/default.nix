{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.apps.vscode;
in
{
  options.${namespace}.apps.vscode = {
    enable = lib.mkEnableOption "vscode";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.override {
        commandLineArgs = [
          "--ozone-platform=wayland"
          "--enable-wayland-ime"
        ];
      };
    };
  };

}
