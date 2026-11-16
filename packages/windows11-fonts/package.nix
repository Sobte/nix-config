{
  lib,
  stdenvNoCC,
  fetchurl,
  p7zip,

  languages ? import ./languages.nix,
  os ? "Microsoft Windows 11",
  ...
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "windows11-fonts";
  version = "10.0.26300.9457-1";

  src = fetchurl {
    url = "https://software-static.download.prss.microsoft.com/dbazure/26300.9457.260913-1737.26h2_ge_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso";
    hash = "sha256-vD8kCG663JRIkGa1rXgIniz1w0kekOeQu4GisZnBDjg=";
    # Don't ever cache this
    meta.license = lib.licenses.unfree;
  };

  sources = lib.mapAttrs (
    _name: lib.concatMapStringsSep " " (font: "Windows/Fonts/${font}")
  ) languages;
  outputs = [ "out" ] ++ builtins.attrNames finalAttrs.sources;

  __structuredAttrs = true;

  nativeBuildInputs = [ p7zip ];

  unpackPhase = ''
    runHook preUnpack
    7z x $src
    7z x -aoa sources/install.wim Windows/{Fonts/"*".{ttf,ttc},System32/Licenses/neutral/"*"/"*"/license.rtf}
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype

    for outputName in ''${!outputs[@]} ; do
      install -Dm644 Windows/System32/Licenses/neutral/*/*/license.rtf -t ''${!outputName}/share/licenses

      if [[ -n ''${sources[$outputName]} ]]; then
        install -Dm644 ''${sources[$outputName]} -t ''${outputs[$outputName]}/share/fonts/truetype
        ln -s ''${outputs[$outputName]}/share/fonts/truetype/*.{ttf,ttc} $out/share/fonts/truetype
      fi
    done

    runHook postInstall
  '';

  meta = {
    description = "Some TrueType fonts from ${os} (Arial, Bahnschrift, Calibri, ...)";
    homepage = "https://learn.microsoft.com/typography/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;

    # Set a non-zero priority to allow easy overriding of the
    # fontconfig configuration files.
    priority = 5;
  };
})
