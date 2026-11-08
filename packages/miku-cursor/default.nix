{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "miku-cursor";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "supermariofps";
    repo = "hatsune-miku-windows-linux-cursors";
    rev = "${finalAttrs.version}";
    hash = "sha256-OQjjOc9VnxJ7tWNmpHIMzNWX6WsavAOkgPwK1XAMwtE=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv miku-cursor-linux miku-cursor
    cp -R miku-cursor $out/share/icons/

    runHook postInstall
  '';
  meta = {
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ cafkafk ];
  };
})
