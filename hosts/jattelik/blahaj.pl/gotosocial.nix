_:
let
  account-domain = "blahaj.pl";
  host = "gts.${account-domain}";
  port = 18740;
in
{
  services.gotosocial = {
    enable = true;
    settings = {
      inherit host port account-domain;
      advanced-rate-limit-requests = 1000;
      bind-address = "[::1]";
      db-type = "sqlite";
      metrics-enabled = true;
    };
  };

  services.caddy.virtualHosts."${account-domain}".extraConfig = ''
    redir /.well-known/host-meta* https://${host}{uri} permanent
    redir /.well-known/webfinger* https://${host}{uri} permanent
    redir /.well-known/nodeinfo*  https://${host}{uri} permanent
  '';

  services.caddy.virtualHosts."${host}" = {
    logFormat = "output discard";
    extraConfig = ''
      handle_path /metrics { respond 404; }

      encode zstd gzip
      reverse_proxy * http://[::1]:${toString port} { flush_interval -1 }
    '';
  };

  services.caddy.virtualHosts.":2020" = {
    logFormat = "output discard";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy * http://[::1]:${toString port} { flush_interval -1 }
    '';
  };
}
