{
  cattery = {
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
    };
    room.desktop.dev.enable = true;
    desktop = {
      addons.catppuccin.enable = true;
      plasma.enable = true;
    };
    system.impermanence.enable = true;
  };

  catppuccin.cursors.enable = true;
}
