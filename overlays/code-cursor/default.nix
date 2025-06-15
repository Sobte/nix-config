_: _: prev: {
  code-cursor = prev.code-cursor.overrideAttrs (old: {
    installPhase =
      old.installPhase
      + ''
        substituteInPlace $out/share/applications/cursor-url-handler.desktop --replace-fail "/usr/share/cursor/cursor" "$out/bin/cursor"
      '';
  });
}
