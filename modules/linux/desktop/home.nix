{ pkgs, ... }:
{
  imports = [ ../core/home.nix ];

  home = {
    packages = with pkgs; [
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
