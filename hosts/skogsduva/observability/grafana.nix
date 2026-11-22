{ config, pkgs, ... }: {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "grafana.natalia.ovh";
        enforce_domain = true;
        http_addr = "::1";
        root_url = "https://grafana.natalia.ovh";
      };
      database = {
        type = "sqlite3";
        wal = true;
      };
      users = {
        default_theme = "system";
        home_page = "/dashboards";
        viewers_can_edit = true;
      };
      security = {
        content_security_policy = true;
        content_security_policy_template = ''
          script-src 'self' 'unsafe-eval' 'unsafe-inline' 'strict-dynamic' $NONCE;object-src 'none';font-src 'self';style-src 'self' 'unsafe-inline' blob:;img-src * data:;base-uri 'self';connect-src 'self' grafana.com ws://$ROOT_PATH wss://$ROOT_PATH;manifest-src 'self';media-src 'none';form-action 'self';
        '';
        cookie_samesite = "strict";
        cookie_secure = true;
        disable_initial_admin_creation = true;
        secret_key = "0ddd049d7413569d2a7030aa1eae2e23210e81ad30fc43b2e8ad33748eb95090";
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
      enable = true;
      datasources.settings.datasources = [
        {
          access = "proxy";
          name = "[skogsduva] Prometheus";
          prune = true;
          jsonData.timeInterval = "30s";
          type = "prometheus";
          uid = pkgs.grafana-dashboards.datasourceUid;
          url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
        }
      ];
      dashboards.settings.providers = [
        {
          name = "skogsduva";
          options.path = pkgs.grafana-dashboards;
        }
      ];
    };
  };

  services.caddy.virtualHosts."https://grafana.natalia.ovh" = {
    extraConfig = ''
      import common

      bind [fd7a:115c:a1e0::ed01:8243] [::1]

      reverse_proxy [${config.services.grafana.settings.server.http_addr}]:${toString config.services.grafana.settings.server.http_port}
    '';
  };
}
