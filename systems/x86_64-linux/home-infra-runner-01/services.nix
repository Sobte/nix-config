{ pkgs, ... }:
{
  cattery = {
    services = {
      docker.enable = true;
      gitea-actions-runner = {
        enable = true;
        package = pkgs.forgejo-runner;
        url = "https://git.sobte.dev/";
      };
    };
  };
}
