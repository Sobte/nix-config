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
      dataDir = "/fast/serv-apps/postgresql/data";
    };
    openssh.settings = {
      StreamLocalBindUnlink = true;
    };
    hydra = {
      enable = true;
      hydraURL = "https://home.hydra.oop.icu";
      notificationSender = "hydra@example.com";
      useSubstitutes = true;
      minimumDiskFree = 20;
      minimumDiskFreeEvaluator = 10;
      extraOptions = {
        maxServers = 8;
      };
      extraConfig = "allow_import_from_derivation = true";
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

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    extraCommands = ''
      iptables -I nixos-fw 1 -i br-+ -p tcp --dport 3000 -j ACCEPT
      iptables -I nixos-fw 1 -i docker0 -p tcp --dport 3000 -j ACCEPT
    '';
  };
}
