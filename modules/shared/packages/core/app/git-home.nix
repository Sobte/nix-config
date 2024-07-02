{ pkgs, ... }:
{
  home.packages = with pkgs; [ gitui ];

  programs = {
    # the software people used to convince everyone else to use
    git = {
      enable = true;
      package = pkgs.gitFull;
      lfs.enable = true;

      # idk what im missing out before
      difftastic.enable = true;

      userName = "sobte";
      userEmail = "i@sobte.me";
      extraConfig = {
        # why merge when you can stash & rebase
        pull.rebase = "true";
        # let git resolve conflicts for you
        rerere.enabled = "true";
        # the one git command that have nothing to do with git
        # (this options makes branches display in grid, much better experience)
        column.ui = "auto";
        # actually, vscode does this by default and it's much better,
        # should set this in cli too
        branch.sort = "-committerdate";
        # I still left wondering how on earth would I configure repo maintenance

        init.defaultBranch = "main";
      };
    };

    # the thing i use to auth the thing just above
    gh.enable = true; # ok it's github cli
  };
}
