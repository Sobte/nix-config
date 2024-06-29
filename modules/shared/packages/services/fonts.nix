{ pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  fonts =
    let
      packages = with pkgs; [
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
    in
    {
      inherit packages;
    }
    // (
      if (!isDarwin) then
        {
          fontDir.enable = true;
          fontconfig.defaultFonts = {
            # Source Han Serif
            serif = [
              "Source Han Serif SC"
              "Source Han Serif TC"
              "Noto Color Emoji"
            ];
            # Source Han Sans
            sansSerif = [
              "Source Han Sans SC"
              "Source Han Sans TC"
              "Noto Color Emoji"
            ];
            # Fira Code
            monospace = [
              "Fira Code"
              "Noto Color Emoji"
            ];
            # Nerd Fonts
            emoji = [ "Noto Color Emoji" ];
          };
        }
      else
        { }
    );
}
