{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.cli-apps.tool.useful;
in
{
  options.${namespace}.cli-apps.tool.useful = {
    enable = lib.mkEnableOption "useful";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # cli utils
        fd # better find, why debian uses `fd-find` still bothers me
        jq # i should learn this
        eza # ls
        ripgrep # grep
        lrzsz # communication package providing the XMODEM, YMODEM ZMODEM file transfer protocols
        parallel # for executing jobs in parallel using one or more computers
        rsync # fast incremental file transfer utility
        rclone # command line program to sync files and directories to and from major cloud storage
        smartmontools # tools for monitoring the health of hard drives
        tldr # simplified and community-driven man pages
        tokei # a program that allows you to count your code, quickly
        xz # a general-purpose data compression software, successor of LZMA
        zstd # zstandard real-time compression algorithm
        iperf # tool to measure IP bandwidth using UDP or TCP
        nmap # a free and open source utility for network discovery and security auditing
        rmlint # file dedupe
        wrk # http benchmarking tool
        oha # http load generator inspired by rakyll/hey with tui animation
        pciutils # lspci
        openssl # a cryptographic library that implements the SSL and TLS protocols
        tree # command to produce a depth indented directory listing

        # tui
        dua # most convenient disk stuff I've ever used
      ];

      shellAliases = {
        cat = "bat";
        diff = "difft";
        ls = "eza";
      };
    };

    programs = {
      # the cat replacement that actually does something
      bat.enable = true;

      # great file fuzzy finder
      fzf.enable = true;

      # use zoxide to replace cd
      zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
      };
    };
  };

}
