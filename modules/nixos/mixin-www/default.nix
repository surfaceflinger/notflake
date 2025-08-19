_: {
  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
      80
      443
    ];
  };

  services.caddy = {
    enable = true;
    email = "ssl@nekopon.pl";
    enableReload = false;
    globalConfig = ''
      cert_issuer acme https://acme-v02.api.letsencrypt.org/directory {
        profile tlsserver
      }

      admin off
      metrics { per_host }
    '';
    extraConfig = ''
      (common) {
        tls {
          protocols tls1.3
        }

        header {
          ?Permissions-Policy interest-cohort=()
          >Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
          ?X-Content-Type-Options nosniff
          ?X-Frame-Options DENY
        }
      }
    '';
    virtualHosts.":2019" = {
      logFormat = "output discard";
      extraConfig = "route /metrics { metrics }";
    };
  };
}
