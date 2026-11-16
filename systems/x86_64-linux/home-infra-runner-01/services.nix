{
  inputs,
  catteryNs,
  ...
}:
let
  instance = "home-infra-runner-01";
  runner = inputs.hosts-secrets.lib.settings.forgejo.runners.${instance};
in
{
  ${catteryNs}.services = {
    docker.enable = true;
    forgejo-runner = {
      enable = true;
      instances.${instance} = {
        url = "https://${inputs.hosts-secrets.lib.settings.domains.git}/";
        # `services.forgejo-runner` does not register runners; the UUID must
        # match the existing record in Forgejo, otherwise it creates a new
        # runner. The value is kept in the private hosts-secrets repo.
        inherit (runner) uuid;
        labels = [
          "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest"
          "ubuntu-22.04:docker://gitea/runner-images:ubuntu-22.04"
          "ubuntu-20.04:docker://gitea/runner-images:ubuntu-20.04"
        ];
      };
    };
  };
}
