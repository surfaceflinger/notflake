{
  cmake,
  fetchFromGitHub,
  lib,
  libsForQt5,
  libxcb,
  ninja,
  qt6,
  stdenv,
  useQt6 ? true,
}:
let
  qtBase = if useQt6 then qt6.qtbase else libsForQt5.qtbase;
  buildInputs =
    if useQt6 then
      [ qt6.qtbase ]
    else
      [
        libsForQt5.qtbase
        libsForQt5.qtx11extras
        libxcb
      ];
in
stdenv.mkDerivation {
  pname = if useQt6 then "libadwaita-qt" else "libadwaita-qt5";
  version = "0-unstable-2026-10-15";

  src = fetchFromGitHub {
    owner = "vagabund";
    repo = "libadwaita-qt";
    rev = "4d964802e822168d6db7e2f4bc778dd595f3801b";
    hash = "sha256-vTv9c80AWeaVa8Fy4wMeDdBdWtrEUPcoXQ9tG6RSeIo=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];
  inherit buildInputs;

  dontWrapQtApps = true;

  cmakeFlags = [
    (if useQt6 then "-DUSE_QT6=ON" else "-DUSE_QT6=OFF")
    "-DCMAKE_BUILD_TYPE=Release"
    "-DQT_PLUGINS_DIR=${placeholder "out"}/${qtBase.qtPluginPrefix}"
    "-DCMAKE_INSTALL_RPATH=${placeholder "out"}/lib"
  ];

  meta = {
    description = "Libadwaita-style widget theme for Qt";
    homepage = "https://github.com/vagabund/libadwaita-qt";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
