{ config, pkgs, ... }:
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
      enable = true;
      datasources.settings.datasources = [
        {
          access = "proxy";
          name = "[skogsduva] Prometheus";
          prune = true;
          type = "prometheus";
          uid = "skogsduva-prometheus";
          url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
        }
      ];
      dashboards.settings.providers =
        let
          fetchDashboard =
            {
              name,
              hash,
              id,
              version,
            }:
            pkgs.fetchurl {
              inherit name hash;
              url = "https://grafana.com/api/dashboards/${toString id}/revisions/${toString version}/download";
              recursiveHash = true;
              postFetch = ''
                mv "$out" temp
                sed -i 's/''${DS_PROMETHEUS}/skogsduva-prometheus/g' temp
                mkdir -p "$out"
                mv temp "$out/${name}.json";
              '';
            };
          dashboard = name: fetchArgs: {
            inherit name;
            options.path = fetchDashboard fetchArgs;
          };
        in
        [
          (dashboard "Node Exporter Full" {
            name = "node-exporter-full";
            hash = "sha256-ti/AY15FYlKm0w7I8t4jVKvAvMRkK0xCTR1zBx6JLQU=";
            id = 1860;
            version = 41;
          })
          (dashboard "OpenWRT" {
            name = "asus-openwrt-router";
            hash = "sha256-fXYPL6MdWA4mbkmi0KSJfswVenenbPaG831YM4GtX9g=";
            id = 18153;
            version = 4;
          })
          (dashboard "Caddy" {
            name = "caddy";
            hash = "sha256-AF0PA5gDlVBp0r+py9QAT3UcZcEwpu75Wxf4ma7cGFc=";
            id = 22870;
            version = 3;
          })
        ];
    };
  };

  services.caddy.virtualHosts."http://grafana.natalia.ovh" = {
    extraConfig = ''
      bind [fd7a:115c:a1e0::ed01:8243] [::1]

      reverse_proxy [${config.services.grafana.settings.server.http_addr}]:${toString config.services.grafana.settings.server.http_port}
    '';
  };
}
