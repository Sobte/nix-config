{
  namespace,
  lib,
  catteryNs,
  ...
}:
{
  ${catteryNs} = {
    room.desktop.general = {
      enable = true;
    };
    desktop.hyprland = {
      theme = {
        charm-cat = {
          enable = true;
          wallpaper.settings = {
            wallpaperDir = lib.${namespace}.host.wallpaper.dir;
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
