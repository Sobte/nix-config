{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.p7zip;
in
{
  options.${namespace}.cli-apps.tool.p7zip = {
    enable = lib.mkEnableOption "p7zip";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # cli stuff
      p7zip
    ];
  };

}
