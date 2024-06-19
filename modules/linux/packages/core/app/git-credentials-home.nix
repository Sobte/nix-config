{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # common lib
      libsecret # for git credentials
    ];
  };

  programs = {
    git.extraConfig = {
      credential.helper = "/etc/profiles/per-user/$(whoami)/bin/git-credential-libsecret";
    };
  };
}
