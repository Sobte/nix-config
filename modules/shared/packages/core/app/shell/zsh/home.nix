{
  programs = {
    # zsh is still supported more widely than fish,
    # tho I probably should try fish, maybe later.
    zsh = {
      enable = true;

      # for convenience, like aliases.
      # many plugins have home-manager support, so no need for omz plugin stuff
      oh-my-zsh.enable = true;

      # make it more fish
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
