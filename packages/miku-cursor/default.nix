{
  fetchFromGitHub,
  gawk,
  imagemagick,
  lib,
  stdenvNoCC,
  xcur2png,
}:
let
  # gnome 51 only renders svg cursors from cursors_scalable/
  xcursor2svg = fetchFromGitHub {
    owner = "daiyosei";
    repo = "xcursor2svg";
    rev = "6f9559743739931afe369c9b904e08e7c6a2531a";
    hash = "sha256-ccpa7wIWUbH5qqdwLPkYeNfzzk1p4mzQA+af7SYLlJU=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "miku-cursor";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "supermariofps";
    repo = "hatsune-miku-windows-linux-cursors";
    rev = "${finalAttrs.version}";
    hash = "sha256-OQjjOc9VnxJ7tWNmpHIMzNWX6WsavAOkgPwK1XAMwtE=";
  };

  nativeBuildInputs = [
    gawk
    imagemagick
    xcur2png
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv miku-cursor-linux miku-cursor
    cp -R miku-cursor $out/share/icons/

    bash ${xcursor2svg}/xcursor2svg.sh --res 64 -n $out/share/icons/miku-cursor
    # librsvg smooths embedded bitmaps unless told not to; 64 is an exact
    # multiple of the 32px pixel art
    find miku-cursor-svg-64x64/cursors_scalable -name '*.svg' -exec sed -i 's|<image |<image image-rendering="pixelated" |' {} +
    cp -R miku-cursor-svg-64x64/cursors_scalable $out/share/icons/miku-cursor/

    runHook postInstall
  '';
  meta = {
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ cafkafk ];
  };
})
