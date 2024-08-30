{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.shared.system.fonts;
in
{
  options.${namespace}.shared.system.fonts = {
    enable = lib.mkEnableOption "fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      open-sans
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji

      # Source Han is a set of Pan-CJK fonts from Adobe
      source-sans
      source-serif
      source-han-sans
      source-han-serif

      fira-code
      fira-code-symbols
      monaspace
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
          "Iosevka"
          "Monaspace"
        ];
      })

      # DejaVu contains a lot of mathematical and other symbols, arrows, braille patterns
      dejavu_fonts
      # TODO port ttf-ms-win11-auto
    ];
  };

}
