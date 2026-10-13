{ stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firefox-gnome-theme";
  version = "153";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PbnJr+eB+9Czol3ReI83dUgEhcn0sDK6TSy6ODTQm88=";
  };

  dontConfigure = true;
  dontBuild = true;

  postPatch = ''
    patchShebangs ./scripts
    substituteInPlace ./scripts/auto-install.sh \
      --replace-fail \
        'installScript="./scripts/install.sh"' \
        'installScript="${placeholder "out"}/bin/install.sh"' \
      --replace-fail \
        'eval "chmod +x ''${installScript}"' \
        ""
    substituteInPlace ./scripts/install.sh \
      --replace-fail \
        'THEMEDIRECTORY=$(cd "$(dirname $0)" && cd .. && pwd)' \
        'THEMEDIRECTORY="${placeholder "out"}/share/firefox-gnome-theme"' \
      --replace-fail \
        'cp -fR "$THEMEDIRECTORY/."' \
        'cp -fR --no-preserve=mode "$THEMEDIRECTORY/."' \
      --replace-fail \
        'mv chrome/firefox-gnome-theme/configuration/user.js' \
        'cp chrome/firefox-gnome-theme/configuration/user.js'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 ./scripts/{auto-,}install.sh -t $out/bin
    install -Dm644 ./icon.svg ./user{Chrome,Content}.css -t $out/share/firefox-gnome-theme
    install -Dm644 ./configuration/user.js -t $out/share/firefox-gnome-theme/configuration
    cp -r ./theme $out/share/firefox-gnome-theme

    runHook postInstall
  '';
})
