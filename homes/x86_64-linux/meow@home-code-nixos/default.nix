{
  cattery = {
    cli-apps = {
      dev-kit = {
        jujutsu.enable = true;
      };
      tool = {
        installer.enable = true;
        claude-code.enable = true;
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

  catppuccin.cursors.enable = true;
}
