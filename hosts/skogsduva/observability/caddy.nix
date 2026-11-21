{ config, pkgs, ... }:
{
  age.secrets.caddy-desec-skogsduva.file = ../../../secrets/caddy-desec-skogsduva.age;

  services.caddy = {
    environmentFile = config.age.secrets.caddy-desec-skogsduva.path;
    package = pkgs.caddy-desec;
    globalConfig = ''
      acme_dns desec {
        token {env.DESEC_API_TOKEN}
      }
    '';
  };
}
