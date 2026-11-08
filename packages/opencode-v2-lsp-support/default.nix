{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage {
  pname = "opencode-v2-lsp-support";
  version = "0-unstable-2026-11-08";

  src = fetchFromGitHub {
    owner = "christensenjairus";
    repo = "opencode-v2-lsp-support";
    rev = "e055c985c4aeef9a557093832bf2c36fbe99a549";
    hash = "sha256-6jjXI1j1idbQuj6j8NWzsW4/JPBPoUYltHXd16dP7Xw=";
  };

  npmDepsHash = "sha256-hqNv0pDy418xkbVKgXSQHJw56OLjXUWcIYRHmb01d4E=";

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r . $out/
    runHook postInstall
  '';

  meta = {
    description = "LSP support plugin for OpenCode V2";
    homepage = "https://github.com/christensenjairus/opencode-v2-lsp-support";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
