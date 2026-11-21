{ caddy }:
caddy.withPlugins {
  plugins = [ "github.com/caddy-dns/desec@v1.1.1-0.20260823104132-2b5f3e5f5585" ];
  hash = "sha256-75g3JFHsuPgS4gUffSV/jw78izBiWBA3VrABAtW+iOg=";
}
