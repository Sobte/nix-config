{...}: {
  imports = [
    ../shared/home.nix
  ];

  programs = {
    zsh.initExtra = ''
      # pnpm
      export PNPM_HOME="/Users/meow/Library/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac
      # pnpm end
    '';
  };
}
