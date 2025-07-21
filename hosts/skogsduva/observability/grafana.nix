{ config, ... }:
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "grafana.natalia.ovh";
        enforce_domain = true;
        http_addr = "::1";
      };
      database = {
        type = "sqlite3";
        wal = true;
      };
      users = {
        default_theme = "system";
        viewers_can_edit = true;
      };
      security = {
        content_security_policy = true;
        cookie_samesite = "strict";
        disable_initial_admin_creation = true;
        x_xss_protection = false;
      };
      analytics = {
        check_for_plugin_updates = false;
        check_for_updates = false;
        enabled = false;
        feedback_links_enabled = false;
        reporting_enabled = false;
      };
      "auth.anonymous".enabled = true;
    };
    provision = {
      datasources.settings.datasources = [
        {
          access = "proxy";
          name = "[skogsduva] Prometheus";
          prune = true;
          type = "prometheus";
          url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
        }
      ];
      enable = true;
    };
  };

  services.caddy.virtualHosts."http://grafana.natalia.ovh" = {
    extraConfig = ''
      bind [fd7a:115c:a1e0::ed01:8243] [::1]

      reverse_proxy [${config.services.grafana.settings.server.http_addr}]:${toString config.services.grafana.settings.server.http_port}
    '';
  };
}
