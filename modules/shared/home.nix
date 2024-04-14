{
  pkgs,
  inputs,
  ...
}: let
  nodejs = pkgs.nodejs_21;
in {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  home = {
    stateVersion = "24.05";

    packages = with pkgs; [
      # nix stuff
      alejandra
      nil # nix language server

      # cli utils
      wget # fetch thing i don't use
      curl # fetch thing i do use
      fd # better find, why debian uses `fd-find` still bothers me
      jq # i should learn this
      eza # ls
      ripgrep
      aria # no 2 needed
      gnupg
      lrzsz
      parallel
      rsync
      rclone
      smartmontools
      tldr
      tokei
      xz
      zstd
      yt-dlp
      iperf
      nmap
      rmlint # file dedupe
      wrk
      oha
      pciutils # lspci

      # tui
      btop
      htop
      glances
      inxi # yep i have 4 monitoring tools for some reason
      dua # most convenient disk stuff I've ever used
      gitui
      dive

      # databases
      postgresql_16_jit # til: postgres has jit
      sqlite

      # cloud
      turso-cli
      awscli2

      # visual stuff
      brotli
      ffmpeg-full
      imagemagick
      flac
      libheif
      libwebp
      optipng

      # c
      autoconf
      automake
      cmake

      # wasm
      binaryen
      emscripten

      # js
      nodejs
      nodejs.pkgs.yarn
      nodejs.pkgs.pnpm
      bun
      dprint

      # rust
      rustup
      sccache

      # lua
      luajit

      # dotnet
      dotnet-sdk_8
      
      # python
      python3

      # k8s
      kubectl
      kubernetes-helm
      argocd # just to help with configs at work
    ];
  };

  programs = {
    # let home-manager install and manage itself
    home-manager.enable = true;

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

      shellAliases = {
        cat = "bat";
        diff = "difft";
        ls = "eza";
      };
    };

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

    # the cat replacement that actually does something
    bat.enable = true;

    # great file fuzzy finder
    fzf.enable = true;

    # use zoxide to replace cd
    zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };

    # used to use headline, tho kinda slow, so switched to starship
    starship = {
      enable = true;
      # using toml here to benefit from schema & lsp
      settings = builtins.fromTOML (builtins.readFile ./config/starship.toml);
    };

    # zsh history is just too smol
    atuin = {
      enable = true;
      settings = {
        auto_sync = true; # remember to login with `atuin login -u <USERNAME>`
        enter_accept = true;
        style = "compact";
      };
    };

    # rarely used these days but kinda handy
    thefuck.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # command not found in nix
    nix-index.enable = true;

    # java programming language
    java = {
      enable = true;
      package = pkgs.graalvm-ce;
    };

    # go programming language
    go = {
      enable = true;
    };

  };
}
