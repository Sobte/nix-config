{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;

  pnpmHome =
    if isDarwin then
      "/Users/${config.${namespace}.user.name}/Library/pnpm"
    else
      "$HOME/.local/share/pnpm";
  cfg = config.${namespace}.cli-apps.dev-kit.javascript;
in
{
  options.${namespace}.cli-apps.dev-kit.javascript = {
    enable = lib.mkEnableOption "javascript";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # js
      nodejs_22
      corepack_22
      bun
      dprint
    ];

    programs.zsh.initExtra = lib.mkAfter ''
      # pnpm
      export PNPM_HOME="${pnpmHome}"
      # check pnpm home exists in path
      if [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
          export PATH="$PATH:$PNPM_HOME"
      fi
    '';
  };

}
