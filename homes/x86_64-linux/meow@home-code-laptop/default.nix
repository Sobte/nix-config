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
      niri.theme = {
        cozy-meow = {
          enable = true;
          wallpaper.imagePath = "${inputs.wallpapers}/wide/default";
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

  catppuccin.swaylock.enable = false;
  # catppuccin.cursors.enable = true;
}
