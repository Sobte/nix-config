{
  pkgs,
  inputs,
  catteryNs,
  ...
}:
{
  ${catteryNs} = {
    services = {
      docker.enable = true;
      gitea-actions-runner = {
        enable = true;
        package = pkgs.forgejo-runner;
        url = "https://${inputs.hosts-secrets.lib.settings.domains.git}/";
      };
    };
  };
}
