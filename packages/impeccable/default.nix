{
  fetchurl,
  lib,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "impeccable";
  version = "4.7.0";

  src = fetchurl {
    url = "https://github.com/pbakaus/impeccable/releases/download/skill-v${finalAttrs.version}/universal.zip";
    hash = "sha256-NYyLa7whE+mRC/StvbpFI2EkU+xY1WpcGxRlRBahP+M=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip -q "$src"
  '';

  installPhase = ''
    runHook preInstall

    install -d "$out/share/impeccable"
    cp -r .opencode "$out/share/impeccable"

    runHook postInstall
  '';

  meta = {
    description = "Design guidance skill for AI coding agents";
    homepage = "https://github.com/pbakaus/impeccable";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
