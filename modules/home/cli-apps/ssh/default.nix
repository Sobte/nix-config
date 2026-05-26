{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:
let
  inherit (config.snowfallorg.user) name;

  cfg = config.${namespace}.cli-apps.ssh;

  remoteConfig = "${config.cattery.user.home}/.ssh/remote_config";
  customConfig = "${config.cattery.user.home}/.ssh/custom_config";

  mergeRemoteConfig = pkgs.writeShellApplication {
    name = "merge-remote-ssh-config";

    runtimeInputs = with pkgs; [
      coreutils
      gawk
    ];

    text = ''
      set -eu

      target="${remoteConfig}"

      block="${config.cattery.secrets.shared.users.${name}.files."ssh/block_config".path}"
      known="${config.cattery.secrets.shared.users.${name}.files."ssh/known_hosts".path}"

      tmp="$(mktemp)"

      mkdir -p "$(dirname "$target")"

      {
        printf '%s\n' \
          "Include ${customConfig}" \
          "UserKnownHostsFile ~/.ssh/known_hosts $known"

        printf '\n'
      } > "$tmp"

      awk '
        function flush() {
          if (host == "")
            return

          if (!(host in seen)) {
            seen[host] = 1
            printf "%s", data
          }
        }

        function reset() {
          host = ""
          data = ""
        }

        BEGIN {
          reset()
        }

        FNR == NR {
          if ($1 == "Host") {
            flush()
            host = $2
            data = $0 "\n"
            next
          }

          data = data $0 "\n"

          next
        }

        {
          if (!reading_old) {
            flush()
            reset()
            reading_old = 1
          }

          if ($1 == "Host") {
            flush()
            host = $2
            data = $0 "\n"
            next
          }

          data = data $0 "\n"
        }

        END {
          flush()
        }
      ' \
        "$block" \
        "$target" 2>/dev/null >> "$tmp" || true

      mv "$tmp" "$target"

      chmod 600 "$target"
    '';
  };

in
{
  options.${namespace}.cli-apps.ssh = {
    homeBlock.enable = lib.mkEnableOption "ssh home block";
  };

  config = lib.mkIf cfg.homeBlock.enable {
    cattery = {
      secrets = {
        shared.users.${name}.files = {
          "ssh/known_hosts" = { };
          "ssh/block_config" = { };
        };
      };
      cli-apps = {
        ssh = {
          enable = true;
          includes = [
            "${remoteConfig}"
          ];
        };
      };
    };

    # after the secrets are activated
    systemd.user.services.agenix.Service.ExecStartPost = lib.mkAfter [
      "${lib.getExe mergeRemoteConfig}"
    ];

    launchd.agents.merge-remote-ssh-config = {
      enable = true;

      config = {
        ProgramArguments = [
          "${lib.getExe mergeRemoteConfig}"
        ];

        RunAtLoad = true;

        ProcessType = "Background";

        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/merge-ssh.out";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/merge-ssh.err";
      };
    };
  };
}
