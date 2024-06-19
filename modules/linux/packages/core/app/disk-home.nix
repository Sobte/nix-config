{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # disk stuff
      ifuse # for ios
      mtools # NTFS
      nfs-utils # nfs
    ];
  };
}
