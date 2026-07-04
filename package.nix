{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  cairo,
  pango,
  systemd,
  at-spi2-core,
  qt6,
  glib,
  libxext,
  libxcomposite,
  libxdamage,
  libxfixes,
  libxrandr,
  libx11,
  libxcb,
  nspr,
  nss,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coccoc-browser";
  version = "147.0.7727.150";

  src = fetchurl {
    url = "https://browser-linux.coccoc.com/deb/pool/main/coccoc-browser-stable_147.0.7727.150-1_amd64.deb";
    hash = "sha256-MwQRQiEHdMyTY5E3LxhA7a+/T/eAEGBoCf8NhiFxkYE=";
  };

  icon = fetchurl {
    name = "coccoc.png";
    url = "https://coccoc.com/assets/images/home/compare/coccoc.png";
    hash = "sha256-V0c3WZhC/Ob6Zde8oSGxpaXz9HSJjM+ZqGOF6HfKSL8=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    cairo
    pango
    systemd
    at-spi2-core
    stdenv.cc.cc.lib
    qt6.qtbase
    glib
    libxext
    libxcomposite
    libxdamage
    libxfixes
    libxrandr
    libx11
    libxcb
    nspr
    nss
    alsa-lib
  ];

  dontWrapQtApps = true;

  unpackPhase = ''
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt $out/share

    cp -R opt/coccoc $out/opt/
    cp -R usr/share/* $out/share/

    # delete qt5 shim to prevent dependency collision    
    rm $out/opt/coccoc/browser/libqt5_shim.so

    ln -s $out/opt/coccoc/browser/coccoc-browser $out/bin/coccoc-browser

    install -Dm644 $icon $out/share/icons/hicolor/256x256/apps/coccoc.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Cốc Cốc Browser";
      exec = "coccoc-browser";
      icon = "coccoc";
      desktopName = "Cốc Cốc Browser";
      comment = finalAttrs.meta.description;
      categories = [
        "Network"
      ];
      terminal = false;
    })
  ];

  meta = {
    description = "Cốc Cốc! The optimized web browser for vietnamese people";
    homepage = "https://coccoc.com/";
    maintainers = with lib.maintainers; [ aanhlongg ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainProgram = "coccoc-browser";
  };
})
