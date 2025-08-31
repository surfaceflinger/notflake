{ fetchFromGitHub, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "nokia-fonts";
  version = "0-unstable-2021-06-16";

  src = fetchFromGitHub {
    owner = "maemo-leste";
    repo = "ui-fonts";
    rev = "3a14210e123317096bb529288462cc84b8f0c781";
    hash = "sha256-OBeWACDPOZqWnJxCecuS+4WGowTZwvHkpj3N12qDqag=";
  };

  installPhase = ''
    install -m444 -Dt $out/share/fonts/truetype $src/fonts/nokia/*
  '';
}
