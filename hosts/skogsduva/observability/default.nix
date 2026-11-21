{ ... }: {
  imports = [
    ./caddy.nix
    ./grafana.nix
    ./json.nix
    ./prometheus.nix
  ];
}
