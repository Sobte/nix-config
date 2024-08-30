{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = config.${namespace}.cli-apps.git-credentials;
in
{
  options.${namespace}.cli-apps.git-credentials = {
    enable = lib.mkEnableOption "git credentials";
  };

  config = lib.mkIf (cfg.enable && isLinux) {
    home.packages = with pkgs; [
      # common lib
      libsecret # for git credentials
    ];

    programs = {
      git.extraConfig = {
        credential.helper = "/etc/profiles/per-user/$(whoami)/bin/git-credential-libsecret";
      };
    };
  };

}
