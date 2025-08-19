{ config, ... }:
let
  bind = "[::1]:9595";
  domain = "paste.blahaj.pl";
in
{
  age.secrets.wastebin.file = ../../../secrets/wastebin.age;

  services.wastebin = {
    enable = true;
    secretFile = config.age.secrets.wastebin.path;
    settings = {
      WASTEBIN_ADDRESS_PORT = bind;
      WASTEBIN_BASE_URL = "https://${domain}";
      WASTEBIN_MAX_BODY_SIZE = 5242880;
      WASTEBIN_MAX_PASTE_EXPIRATION = 31536000;
      WASTEBIN_THEME = "coldark";
      WASTEBIN_TITLE = ".: blahajbin :.";
    };
  };

  services.caddy.virtualHosts."${domain}".extraConfig = ''
    import common

    reverse_proxy http://[::1]:9595
  '';
}
