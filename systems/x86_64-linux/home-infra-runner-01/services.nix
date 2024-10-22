{
  cattery = {
    services = {
      docker.enable = true;
      gitea-actions-runner = {
        enable = true;
        url = "https://git.sobte.dev/";
      };
    };
  };
}
