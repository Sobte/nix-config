{
  pkgs,
  ...
}:
{
  cattery.services = {
    docker.enable = true;
    wg-quick.configNames = [ "wg-come-home" ];
    vscode-server.enable = true;
    target.useWizard = true;
    samba.useWizard = true;
    nfs.useWizard = true;
    syncoid = {
      interval = "hourly";
      commands = {
        "fast" = {
          target = "tank/serv-backups";
          recursive = true;
        };
      };
      commonArgs = [
        "--no-sync-snap"
        "--delete-target-snapshots"
      ];
    };
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
        "tank/home-photos" = {
          recursive = true;
        };
        "tank/home-resources" = {
          recursive = true;
        };
        "tank/home-archives" = {
          recursive = true;
        };
        "tank/home-infra" = {
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
      extraConfig = ''
        allow_import_from_derivation = true
      '';
    };
  };

  systemd = {
    services.sync-pve-images = {
      description = "Reflink ISO images from home-resources into PVE image storage";
      after = [ "zfs.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart =
          let
            script = pkgs.writeShellScript "sync-pve-images" ''
              set -euo pipefail
              mkdir -p /tank/home-infra/images/template/iso
              for src in /tank/home-resources/Linux /tank/home-resources/Windows; do
                find "$src" -type f \( -iname '*.iso' -o -iname '*.qcow2' \) -print0 | while IFS= read -r -d "" f; do
                  base="$(basename "$f")"
                  [ -e "/tank/home-infra/images/template/iso/$base" ] || cp --reflink=auto -n "$f" "/tank/home-infra/images/template/iso/$base"
                done
              done
              mkdir -p /tank/home-infra/images/template/cache
              find /tank/home-resources/Linux/LXC-Templates -type f \( -iname '*.tar.zst' -o -iname '*.tar.xz' \) -print0 2>/dev/null | while IFS= read -r -d "" f; do
                base="$(basename "$f")"
                [ -e "/tank/home-infra/images/template/cache/$base" ] || cp --reflink=auto -n "$f" "/tank/home-infra/images/template/cache/$base"
              done
            '';
          in
          "${script}";
      };
    };
    timers.sync-pve-images = {
      description = "Daily reflink sync of ISO images to PVE storage";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
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

  # Persist deploy/watchdog logs across reboots (impermanence keeps /var/log).
  services.journald.extraConfig = ''
    Storage=persistent
  '';

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
