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
            ];
          }
          {
            labels.role = "workstation";
            targets = [ "blahaj:9100" ];
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
    ];
  };

  services.caddy.virtualHosts."http://prometheus.natalia.ovh" = {
    logFormat = "output discard";
    extraConfig = ''
      bind [fd7a:115c:a1e0::ed01:8243] [::1]

      reverse_proxy [::1]:9090 { header_up X-Forwarded-For {remote_host} }
    '';
  };
}
