{
  pkgs,
  lib,
  host,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  home = {
    packages = with pkgs; [
      # js
      nodejs_22
      corepack_22
      bun
      dprint
    ];
  };

  programs.zsh.initExtra = lib.mkAfter (
    let
      pnpmHome = if isDarwin then "/Users/${host.username}/Library/pnpm" else "$HOME/.local/share/pnpm";
    in
    ''
      # pnpm
      export PNPM_HOME="${pnpmHome}"
      # check pnpm home exists in path
      if [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
          export PATH="$PATH:$PNPM_HOME"
      fi
    ''
  );
}
