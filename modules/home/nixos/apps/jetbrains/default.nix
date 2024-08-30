{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.jetbrains;
in
{
  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      ## jetbrains ide
      jetbrains-toolbox
      ## android studio
      android-studio
    ];
  };
}
