{ inputs, ... }:
{
  cattery = {
    room.desktop.general = {
      enable = true;
    };
    desktop.hyprland = {
      theme = {
        charm-cat = {
          enable = true;
          wallpaper.settings = {
            wallpaperDir = "${inputs.wallpapers}/wide";
            transition = {
              type = "grow";
              step = 90;
              wave = "20,10";
              pos = "top-left";
            };
          };
        };
      };
    };
  };
}
