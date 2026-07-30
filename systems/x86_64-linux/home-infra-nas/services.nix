{ pkgs, ... }:
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
    postgresql = {
      enable = true;
      package = pkgs.postgresql_19;
      ensureDatabases = [ "hydra" ];
      ensureUsers = [
        {
          name = "hydra";
          ensureDBOwnership = true;
        }
      ];
      dataDir = "/fast/serv-apps/postgresql/data";
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
