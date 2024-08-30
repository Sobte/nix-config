{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.apps.useful;
in
{
  options.${namespace}.apps.useful = {
    enable = lib.mkEnableOption "useful";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      # apps
      filezilla # ftp client
      gparted # disk management
      obsidian # markdown notes
      kdePackages.kleopatra # gpg key management
      ventoy-full # usb boot creator
      libreoffice # office suite
    ];
  };

}
