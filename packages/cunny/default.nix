{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "cunny";
  version = "unstable-2025-08-29";

  src = fetchFromGitHub {
    owner = "funnyplanter";
    repo = "CuNNy";
    rev = "906031bb00c15dd6a6bbbaa21c0eb0b724ca8437";
    hash = "sha256-jTWgR9QpCv6Wl+fR3U8SBS3AJ42HiNB+7F57OKyziDs=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mpv-shaders
    cp -r mpv $out/share/mpv-shaders/CuNNy

    runHook postInstall
  '';

  meta = {
    description = "CNN-based realtime upscaling shaders for mpv";
    homepage = "https://github.com/funnyplanter/CuNNy";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.all;
  };
}
