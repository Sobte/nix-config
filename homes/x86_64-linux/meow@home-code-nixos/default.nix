{
  inputs,
  system,
  host,
  namespace,
  catteryNs,
  ...
}:
{
  ${catteryNs} = {
    cli-apps = {
      dev-kit = {
        jujutsu.enable = true;
        git = {
          inherit (inputs.hosts-secrets.lib.settings.git.hosts.${host}) includes;
        };
      };
      tool = {
        installer.enable = true;
        claude-code.enable = true;
        opencode.enable = true;
        pi.enable = true;
        ventoy.enable = true;
        tea = {
          enable = true;
          gitCredentialHelper.hosts = [
            "https://git.sobte.dev"
          ];
        };
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
    };
    system.impermanence.enable = true;
  };

  services.ssh-agent = {
    enable = true;
  };

  # home block
  ${namespace} = {
    cli-apps.ssh.homeBlock.enable = true;
    user.calendar.enable = true;
  };

  home.pointerCursor = {
    enable = true;
    name = "nhmeow-cursor";
    package = inputs.nhmeow-cursor.packages.${system}.nhmeow-cursor;
    size = 32;
  };

  # catppuccin.cursors.enable = true;
}
