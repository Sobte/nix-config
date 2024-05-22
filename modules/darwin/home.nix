{...}: {
  imports = [
    ../shared/home.nix
  ];

  programs = {
    zsh.initExtra = ''
      # pnpm
      export PNPM_HOME="/Users/meow/Library/pnpm"
      # check pnpm home exists in path
      if [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
          export PATH="$PATH:$PNPM_HOME"
      fi
    '';

    vscode.enable = true;
  };
}
