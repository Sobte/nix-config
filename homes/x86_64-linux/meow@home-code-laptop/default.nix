{
  inputs,
  system,
  ...
}:
{
  cattery = {
    cli-apps = {
      dev-kit = {
        jujutsu.enable = true;
      };
      tool = {
        installer.enable = true;
        claude-code.enable = true;
        opencode.enable = true;
      };
    };
    apps = {
      remote = {
        enable = true;
        needs = [
          "krdc"
          "remmina"
        ];
      };
      thunderbird = {
        enable = true;
        search.enable = true;
      };
      zoom-us.enable = true;
      ghostty.enable = true;
      foot.enable = true;
      slack.enable = true;
    };
    room.desktop.dev = {
      enable = true;
      allDevKit = true;
    };
    desktop = {
      addons.catppuccin.enable = true;
      plasma.enable = true;
      hyprland.theme.caelestia = {
        enable = true;
        settings = {
          appearance = {
            transparency.enabled = true;
          };
          background = {
            wallpaperEnabled = true;
          };
          paths.wallpaperDir = "${inputs.wallpapers}/wide";
          general.idle = {
            lockBeforeSleep = true;
            inhibitWhenAudio = true;
            timeouts = [
              {
                timeout = 600; # 10 min
                idleAction = "lock";
              }
              {
                timeout = 900; # 15 min
                idleAction = "dpms off";
                returnAction = "dpms on";
              }
              {
                timeout = 1800; # 30 min
                idleAction = [
                  "systemctl"
                  "suspend-then-hibernate"
                ];
              }
            ];
          };
          launcher = {
            useFuzzy = {
              apps = true;
            };
          };
        };
      };
    };
    system.impermanence.enable = true;
  };

  services.ssh-agent = {
    enable = true;
  };

  # home block
  lovelycat = {
    cli-apps.ssh.homeBlock.enable = true;
  };

  home.pointerCursor = {
    name = "nhmeow-cursor";
    package = inputs.nhmeow-cursor.packages.${system}.nhmeow-cursor;
    size = 32;
  };

  # catppuccin.cursors.enable = true;
}
