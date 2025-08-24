{ config, ... }:
{
  services.prometheus = {
    enable = true;
    webExternalUrl = "http://prometheus.natalia.ovh/";
    retentionTime = "31d";
    listenAddress = "[::1]";
    globalConfig = {
      scrape_interval = "10s";
      scrape_timeout = "5s";
    };
    scrapeConfigs = [
      # self
      {
        job_name = "prometheus";
        static_configs = [
          {
            targets = [
              "${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}"
            ];
          }
        ];
      }
      # grafana
      {
        job_name = "grafana";
        static_configs = [
          {
            targets = [
              "[${config.services.grafana.settings.server.http_addr}]:${toString config.services.grafana.settings.server.http_port}"
            ];
          }
        ];
      }
      # hosts
      {
        job_name = "node";
        static_configs = [
          {
            labels.role = "router";
            targets = [ "_gateway:9100" ];
          }
          {
            labels.role = "server";
            targets = [
              "jattelik:9100"
              "skogsduva:9100"
              "symfonisk:9100"
            ];
          }
          {
            labels.role = "workstation";
            targets = [ "blahaj:9100" ];
          }
        ];
      }
      # hosts - low power
      {
        job_name = "node-lowpower";
        scrape_interval = "60s";
        static_configs = [
          {
            labels.role = "vacuum";
            targets = [
              "valetudo-floor:9100"
              "valetudo-ground:9100"
            ];
          }
        ];
      }
      # json exporter
      {
        job_name = "json_exporter";
        static_configs = [
          {
            targets = [
              "${config.services.prometheus.exporters.json.listenAddress}:${toString config.services.prometheus.exporters.json.port}"
            ];
          }
        ];
      }
      # monero via json exporter
      {
        job_name = "json";
        metrics_path = "/probe";
        params = {
          module = [ "monero" ];
        };
        relabel_configs = [
          {
            source_labels = [ "__address__" ];
            target_label = "__param_target";
          }
          {
            source_labels = [ "__param_target" ];
            target_label = "instance";
          }
          {
            target_label = "__address__";
            replacement = "${config.services.prometheus.exporters.json.listenAddress}:${toString config.services.prometheus.exporters.json.port}";
          }
        ];
        static_configs = [
          {
            # monero
            labels.service = "monero";
            targets = [
              "http://${config.services.monero.rpc.address}:${toString config.services.monero.rpc.port}/get_info"
            ];
          }
        ];
      }
      # caddy
      {
        job_name = "caddy";
        static_configs = [
          {
            labels.service = "caddy";
            targets = [
              "blahaj:2019"
              "jattelik:2019"
              "skogsduva:2019"
            ];
          }
        ];
      }
      # gotosocial
      {
        job_name = "gotosocial";
        static_configs = [
          {
            labels.service = "gotosocial";
            targets = [ "jattelik:2020" ];
          }
        ];
      }
    ];
  };

  services.caddy.virtualHosts."https://prometheus.natalia.ovh" = {
    logFormat = "output discard";
    extraConfig = ''
      import common

      bind [fd7a:115c:a1e0::ed01:8243] [::1]
      tls internal

      reverse_proxy ${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}
    '';
  };
}
