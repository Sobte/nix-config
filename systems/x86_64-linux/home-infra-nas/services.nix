{
  pkgs,
  lib,
  purr,
  inputs,
  catteryNs,
  ...
}:
let
  # Image jobs as exposed by this flake's `images` output: one per
  # host/format pair from self's host registry, so stale jobs (e.g. removed
  # hosts or renamed formats still present in Hydra's history) are ignored.
  imageJobs = lib.concatStringsSep " " (
    lib.flatten (
      lib.mapAttrsToList (
        host: meta: map (fmt: "images.${host}.${fmt}") (meta.images or [ ])
      ) purr.systemMetas
    )
  );
in
{
  ${catteryNs}.services = {
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
      hydraURL = "https://${inputs.hosts-secrets.lib.settings.domains.hydra}";
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

  nix.buildMachines = inputs.hosts-secrets.lib.settings.buildMachines;

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

    # Pull the newest NixOS images Hydra builds into home-resources, keeping
    # the KEEP newest builds per image job (mirrors the jobset keepnr of 3).
    # Products land under /tank/home-resources/Linux/NixOS, so sync-pve-images
    # picks up the *.iso / *.qcow2 automatically for PVE.
    services.sync-nixos-images = {
      description = "Sync latest NixOS images from Hydra into home-resources (keep 3 per job)";
      after = [ "zfs.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart =
          let
            script = pkgs.writeShellApplication {
              name = "sync-nixos-images";
              runtimeInputs = [
                pkgs.curl
                pkgs.jq
              ];
              # Intentional word-splitting of IMAGE_JOBS / build-id lists.
              excludeShellChecks = [
                "SC2012"
                "SC2086"
              ];
              text = ''
                set -euo pipefail
                HYDRA_URL="http://localhost:3000"
                PROJECT="nix-config"
                JOBSET="main"
                DEST="/tank/home-resources/Linux/NixOS"
                KEEP="3"

                  # Image jobs come from self's `images` output via purr.systemMetas.
                IMAGE_JOBS="${imageJobs}"

                mkdir -p "$DEST"

                for job in $IMAGE_JOBS; do
                  dir="$DEST/$job"
                  mkdir -p "$dir"

                  # Newest KEEP successful builds for this job, newest first.
                  ids="$(curl -fsS "$HYDRA_URL/api/latestbuilds?project=$PROJECT&jobset=$JOBSET&job=$job&nr=$KEEP" | jq -r '.[] | select(.buildstatus == 0) | .id' || true)"
                  [ -n "$ids" ] || { echo "[sync-nixos-images] no successful build for $job"; continue; }

                  # Reflink-copy each product file (nix-support excluded) into
                  # <buildid>-<name>, so multiple files of one build stay grouped.
                  for id in $ids; do
                    out="$(curl -fsS "$HYDRA_URL/build/$id/api/get-info" | jq -r '.outPath // empty' || true)"
                    [ -n "$out" ] && [ -d "$out" ] || continue
                    while IFS= read -r -d "" f; do
                      base="$(basename "$f")"
                      dest="$dir/$id-$base"
                      [ -e "$dest" ] || cp --reflink=auto -n "$f" "$dest"
                    done < <(find "$out" \( -type f -o -type l \) ! -path '*/nix-support/*' -print0)
                  done

                  # Prune down to the newest KEEP build ids in this job's directory.
                  keep_ids="$(ls -1 "$dir" | sed -n 's/^\([0-9]*\)-.*/\1/p' | sort -nu | tail -n "$KEEP")"
                  [ -n "$keep_ids" ] || continue
                  for f in "$dir"/*; do
                    [ -f "$f" ] || continue
                    id="''${f##*/}"; id="''${id%%-*}"
                    echo "$keep_ids" | grep -qx "$id" || rm -f "$f"
                  done
                done
              '';
            };
          in
          "${script}/bin/sync-nixos-images";
      };
    };
    timers.sync-nixos-images = {
      description = "Daily sync of Hydra NixOS images into home-resources";
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
