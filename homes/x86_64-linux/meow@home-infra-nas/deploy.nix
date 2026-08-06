{
  pkgs,
  ...
}:
let
  hydraURL = "http://localhost:3000";
  project = "nix-config";
  jobset = "main";
  pollInterval = 60;

  # Machines to auto-deploy after a successful Hydra build. Empty = no auto deploy.
  autoDeploy = [ ];
  autoDeployList = builtins.concatStringsSep " " autoDeploy;

  deployFn = ''
    HYDRA_URL="${hydraURL}"
    PROJECT="${project}"
    JOBSET="${jobset}"

    # Runs as meow, so ssh automatically picks up ~/.ssh/config (name -> IP
    # mapping from remote_config), known_hosts and the default identity key.
    deploy() {
      local machine="$1"
      local out=''${2:-}

      local ssh_opts=(
        -o IdentitiesOnly=yes
        -o BatchMode=yes
      )
      # NIX_SSHOPTS is honored by `nix copy --to ssh-ng://` (nix's built-in ssh transport).
      export NIX_SSHOPTS="''${ssh_opts[*]}"

      if [ -z "$out" ]; then
        local job="nixosConfigurations.x86_64-linux.$machine"
        local build_id
        build_id="$(curl -fsS "$HYDRA_URL/api/latestbuilds?project=$PROJECT&jobset=$JOBSET&job=$job&nr=1" | jq -r '.[0].id')"
        out="$(curl -fsS "$HYDRA_URL/build/$build_id/api/get-info" | jq -r '.outPath')"
        echo "[hydra-deploy] resolved latest successful build $build_id for $job: $out"
      fi

      echo "[hydra-deploy] deploying $machine ($out)"
      nix copy --no-check-sigs --to "ssh-ng://root@$machine" "$out"
      ssh "''${ssh_opts[@]}" "root@$machine" "nix-env --profile /nix/var/nix/profiles/system --set '$out' && '$out'/bin/switch-to-configuration switch"
    }
  '';

  deployPkg =
    name: text:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = with pkgs; [
        curl
        jq
        nix
        openssh
      ];
      # SC2029: `$out` expands on the deploy host, which is intended.
      excludeShellChecks = [ "SC2029" ];
      text = ''
        set -euo pipefail
        ${deployFn}
        ${text}
      '';
    };

  cli = deployPkg "hydra-deploy" ''
    deploy "$@"
  '';

  # One-shot: check every autoDeploy machine once, deploy any with a new
  # successful build. Timed by systemd timer, not a shell loop.
  watchdog = deployPkg "hydra-deploy-watch" ''
    machines="${autoDeployList}"
    [ -n "$machines" ] || exit 0

    for machine in $machines; do
      job="nixosConfigurations.x86_64-linux.$machine"
      build_id="$(curl -fsS "$HYDRA_URL/api/latestbuilds?project=$PROJECT&jobset=$JOBSET&job=$job&nr=1" | jq -r '.[0].id // empty')"
      if [ -z "$build_id" ]; then
        echo "[hydra-deploy] $machine: no successful build yet"
        continue
      fi

      # Skip if this build was already deployed.
      stamp="''${XDG_STATE_HOME:-$HOME/.local/state}/hydra-deploy/$machine"
      mkdir -p "$(dirname "$stamp")"
      last="$(cat "$stamp" 2>/dev/null || true)"
      if [ "$last" = "$build_id" ]; then
        echo "[hydra-deploy] $machine: build $build_id already deployed"
        continue
      fi

      echo "$build_id" > "$stamp"
      if deploy "$machine"; then
        echo "[hydra-deploy] $machine: deployed build $build_id"
      else
        echo "[hydra-deploy] $machine: DEPLOY FAILED for build $build_id" >&2
      fi
    done
  '';
in
{
  home.packages = [ cli ];

  systemd.user.services.hydra-deploy-watch = {
    Unit = {
      Description = "Deploy new Hydra builds to machines in the autoDeploy list";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${watchdog}/bin/hydra-deploy-watch";
    };
  };

  systemd.user.timers.hydra-deploy-watch = {
    Unit = {
      Description = "Periodically run the Hydra auto-deploy check";
    };
    Timer = {
      OnBootSec = toString pollInterval;
      OnUnitActiveSec = toString pollInterval;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
