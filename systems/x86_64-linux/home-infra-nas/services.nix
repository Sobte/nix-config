{
  cattery.services = {
    docker.enable = true;
    wg-quick.configNames = [ "wg-come-home" ];
    vscode-server.enable = true;
    target.useWizard = true;
    samba.useWizard = true;
    sanoid = {
      useWizard = true;
      interval = "*:0,15,30,45";
      datasets = {
        "fast" = {
          recursive = true;
        };
        "tank/serv-backups" = {
          recursive = true;
        };
      };
    };
  };

  users.groups.resource = { };
  users.groups.shared = { };

  users.users.resource = {
    isSystemUser = true;
    group = "resource";
  };
  users.users.shared = {
    isSystemUser = true;
    group = "shared";
  };
}
