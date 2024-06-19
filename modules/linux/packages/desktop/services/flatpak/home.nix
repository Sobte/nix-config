{ lib, ... }:
{
  programs.zsh.initExtra = lib.mkAfter ''
    # XDG_DATA_DIRS add flatpak
    FLATPAK_SYSTEM="/var/lib/flatpak/exports/share"
    FLATPAK_USER="$HOME/.local/share/flatpak/exports/share"
    # check flatpak system exists in XDG_DATA_DIRS
    if [[ ":$XDG_DATA_DIRS:" != *":$FLATPAK_SYSTEM:"* ]]; then
        export XDG_DATA_DIRS="$XDG_DATA_DIRS:$FLATPAK_SYSTEM"
    fi
    # check flatpak user exists in XDG_DATA_DIRS
    if [[ ":$XDG_DATA_DIRS:" != *":$FLATPAK_USER:"* ]]; then
        export XDG_DATA_DIRS="$XDG_DATA_DIRS:$FLATPAK_USER"
    fi
  '';
}
