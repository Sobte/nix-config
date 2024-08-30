{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.dev-kit.cpp;
in
{
  options.${namespace}.cli-apps.dev-kit.cpp = {
    enable = lib.mkEnableOption "cpp";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # c
      autoconf
      automake
      cmake
      gcc
    ];
  };

}
