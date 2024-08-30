{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.ollama;
in
{
  options.${namespace}.cli-apps.tool.ollama = {
    enable = lib.mkEnableOption "ollama";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ollama # llm
    ];
  };

}
