{ pkgs, ... }:
{
  # fcitx5
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-rime
        fcitx5-configtool
      ];
    };
  };
}
