{
  addDriverRunpath,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  cairo,
  cups,
  dbus,
  dpkg,
  expat,
  fetchurl,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  glibc,
  gnutls,
  gtk3,
  lib,
  libGL,
  libx11,
  libxscrnsaver,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  libappindicator,
  libcxx,
  libdbusmenu,
  libdrm,
  libgcrypt,
  libglvnd,
  libnotify,
  libpulseaudio,
  libuuid,
  libxcb,
  libxkbcommon,
  libxkbfile,
  libxshmfence,
  libgbm,
  lshw,
  makeShellWrapper,
  nspr,
  nss,
  pango,
  pciutils,
  pipewire,
  pixman,
  stdenv,
  systemdLibs,
  wayland,
  xdg-utils,
  writeScript,

  # for custom command line arguments, e.g. "--use-gl=desktop"
  commandLineArgs ? "",
  ...
}:

let
  sources = {
    x86_64-linux = fetchurl {
      url = "https://sf16-sg.larksuitecdn.com/obj/lark-version-sg/4c647c08/Lark-linux_x64-8.0.18.deb";
      hash = "sha256-0WFobFrlLWmaFI12QxCGn1XTyoZtV6fiSWOq+oC2ejw=";
    };
    aarch64-linux = fetchurl {
      url = "https://sf16-sg.larksuitecdn.com/obj/lark-version-sg/25ef09d6/Lark-linux_arm64-8.0.18.deb";
      hash = "sha256-LT3UrFsNMPCg0/Ylf6aiggMDBle98ReqV5iAZbj6buw=";
    };
  };

  supportedPlatforms = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  rpath = lib.makeLibraryPath [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    glibc
    gnutls
    libGL
    libx11
    libxscrnsaver
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxtst
    libappindicator
    libcxx
    libdbusmenu
    libdrm
    libgcrypt
    libglvnd
    libnotify
    libpulseaudio
    libuuid
    libxcb
    libxkbcommon
    libxkbfile
    libxshmfence
    libgbm
    nspr
    nss
    pango
    pciutils
    pipewire
    pixman
    stdenv.cc.cc
    systemdLibs
    wayland
    xdg-utils
  ];
in
stdenv.mkDerivation {
  pname = "lark";
  version = "8.0.18";

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    makeShellWrapper
    dpkg
  ];

  buildInputs = [
    gtk3

    # for autopatchelf
    alsa-lib
    cups
    libxdamage
    libxtst
    libdrm
    libgcrypt
    libpulseaudio
    libxshmfence
    libgbm
    nspr
    nss
  ];

  dontUnpack = true;
  installPhase = ''
    runHook preInstall

    # This deb file contains a setuid binary,
    # so 'dpkg -x' doesn't work here.
    dpkg --fsys-tarfile $src | tar --extract
    mkdir -p $out
    mv usr/share $out/
    mv opt/ $out/

    substituteInPlace $out/share/applications/bytedance-lark.desktop \
      --replace-quiet /usr/bin/bytedance-lark-stable $out/opt/bytedance/lark/bytedance-lark

    wrapProgram $out/opt/bytedance/lark/lark \
      --prefix PATH             :  ${lib.makeBinPath [ lshw ]} \
      --prefix XDG_DATA_DIRS    :  "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
      --prefix LD_LIBRARY_PATH  :  ${rpath}:$out/opt/bytedance/lark:${addDriverRunpath.driverLink}/share \
      ${lib.optionalString (commandLineArgs != "") "--add-flags ${lib.escapeShellArg commandLineArgs}"}

    mkdir -p $out/share/icons/hicolor
    base="$out/opt/bytedance/lark"
    for size in 16 24 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      ln -s $base/product_logo_$size.png $out/share/icons/hicolor/''${size}x''${size}/apps/bytedance-lark.png
    done

    mkdir -p $out/bin
    ln -s $out/opt/bytedance/lark/bytedance-lark $out/bin/bytedance-lark
    ln -s $out/opt/bytedance/lark/bytedance-lark $out/bin/lark

    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = writeScript "update-lark.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts

      for platform in ${lib.escapeShellArgs supportedPlatforms}; do
        if [ $platform = "x86_64-linux" ]; then
          platform_id=10
        elif [ $platform = "aarch64-linux" ]; then
          platform_id=12
        else
          echo "Unsupported platform: $platform"
          exit 1
        fi
        package_info=$(curl -sf "https://www.larksuite.com/api/package_info?platform=$platform_id")
        update_link=$(echo $package_info | jq -r '.data.download_link' | sed 's/lf[0-9]*-larkversion-new-sign.larksuitecdn.com/sf16-sg.larksuitecdn.com\/obj/;s/?.*$//')
        new_version=$(echo $package_info | jq -r '.data.version_number' | sed -n 's/.*@V//p')
        sha256_hash=$(nix-prefetch-url $update_link)
        sri_hash=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 $sha256_hash)
        update-source-version lark $new_version $sri_hash $update_link --system=$platform --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    description = "Lark (international version of Feishu) all-in-one collaboration suite";
    homepage = "https://www.larksuite.com/";
    downloadPage = "https://www.larksuite.com/en_us/download";
    license = lib.licenses.unfree;
    platforms = supportedPlatforms;
    mainProgram = "lark";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
