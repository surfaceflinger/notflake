{ config, pkgs, ... }: {
  age.secrets.caddy-desec-jattelik.file = ../../secrets/caddy-desec-jattelik.age;

  services.caddy = {
    environmentFile = config.age.secrets.caddy-desec-jattelik.path;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/desec@v1.1.1-0.20260823104132-2b5f3e5f5585" ];
      hash = "sha256-75g3JFHsuPgS4gUffSV/jw78izBiWBA3VrABAtW+iOg=";
    };
    globalConfig = ''
      dns desec {
        token {env.DESEC_API_TOKEN}
      }
      ech ech.natalia.ovh
    '';
    virtualHosts."www.natalia.ovh, www.nekopon.pl, www.blahaj.pl".extraConfig = ''
      import common

      redir https://{labels.1}.{labels.0}{uri}
    '';
    virtualHosts."natalia.ovh".extraConfig = ''
      import common

      redir https://nekopon.pl
    '';
    virtualHosts."nekopon.pl".extraConfig = ''
      import common

      route {
        header Content-Security-Policy "default-src 'self'; font-src fonts.gstatic.com; style-src 'self' fonts.googleapis.com; object-src 'none'"
        rewrite * /nekopon.pl{uri}
        reverse_proxy https://surfaceflinger.github.io { header_up Host {upstream_hostport} }
      }
    '';
  };
}
