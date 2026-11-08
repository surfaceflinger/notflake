{
  gh,
  github-mcp-server,
  writeShellApplication,
}:
writeShellApplication {
  name = "github-mcp-wrapper";

  runtimeInputs = [
    gh
    github-mcp-server
  ];

  text = ''
    set -euo pipefail
    token="$(gh auth token)"
    export GITHUB_PERSONAL_ACCESS_TOKEN="$token"
    exec github-mcp-server \
      --read-only \
      --toolsets context,repos,git,issues,pull_requests,discussions,actions,labels \
      stdio
  '';
}
