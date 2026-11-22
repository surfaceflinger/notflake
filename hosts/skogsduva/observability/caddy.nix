{ config, pkgs, ... }: {
  age.secrets.caddy-desec-skogsduva.file = ../../../secrets/caddy-desec-skogsduva.age;

  services.caddy = {
    environmentFile = config.age.secrets.caddy-desec-skogsduva.path;
    package = pkgs.caddy-desec;
    globalConfig = ''
      cert_issuer acme https://acme-v02.api.letsencrypt.org/directory {
        profile shortlived
        dns desec {
          token {env.DESEC_API_TOKEN}
        }
        propagation_delay 10m
      }
    '';
  };
}
