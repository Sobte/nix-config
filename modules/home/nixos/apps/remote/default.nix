{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.remote;
in
{
  options.${namespace}.apps.remote = {
    enable = lib.mkEnableOption "remote";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      # rustdesk
      rustdesk
      # kde
      kdePackages.krdc
      # gnome
      remmina
    ];
  };

}
