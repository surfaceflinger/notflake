{
  config,
  lib,
  ...
}:
let
  prom = config.services.prometheus;
  grafana = config.services.grafana.settings.server;
  jsonExporter = prom.exporters.json;
  monero = config.services.monero;

  nodePort = prom.exporters.node.port;
  telemetryHosts = [
    "blahaj"
    "jattelik"
    "skogsduva"
  ];

  scrapeJob =
    {
      name,
      port,
      hosts,
      labels ? { },
      path ? null,
      interval ? null,
    }:
    {
      job_name = name;
      static_configs = [
        (
          {
            targets = map (host: "${host}:${toString port}") hosts;
          }
          // lib.optionalAttrs (labels != { }) { inherit labels; }
        )
      ];
    }
    // lib.optionalAttrs (path != null) { metrics_path = path; }
    // lib.optionalAttrs (interval != null) { scrape_interval = interval; };

  nodeRoles = [
    {
      role = "router";
      targets = [ "_gateway" ];
    }
    {
      role = "server";
      targets = [
        "jattelik"
        "skogsduva"
      ];
    }
    {
      role = "workstation";
      targets = [ "blahaj" ];
    }
    {
      role = "agent";
      targets = [ "sucrose" ];
    }
  ];
in
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
      (scrapeJob {
        name = "prometheus";
        port = prom.port;
        hosts = [ prom.listenAddress ];
      })
      (scrapeJob {
        name = "grafana";
        port = grafana.http_port;
        hosts = [ "[${grafana.http_addr}]" ];
      })
      {
        job_name = "node";
        static_configs = map (
          { role, targets }:
          {
            labels.role = role;
            targets = map (target: "${target}:${toString nodePort}") targets;
          }
        ) nodeRoles;
      }
      (scrapeJob {
        name = "node-lowpower";
        port = nodePort;
        hosts = [
          "valetudo-floor"
          "valetudo-ground"
        ];
        labels.role = "vacuum";
        interval = "60s";
      })
      (scrapeJob {
        name = "node-laptop";
        port = nodePort;
        hosts = [
          "djungelskog"
          "sjorapport"
        ];
        labels.role = "laptop";
        interval = "60s";
      })
      (scrapeJob {
        name = "json_exporter";
        port = jsonExporter.port;
        hosts = [ jsonExporter.listenAddress ];
      })
      # monero goes through the json exporter's probe endpoint
      {
        job_name = "json";
        metrics_path = "/probe";
        params.module = [ "monero" ];
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
            replacement = "${jsonExporter.listenAddress}:${toString jsonExporter.port}";
          }
        ];
        static_configs = [
          {
            labels.service = "monero";
            targets = [
              "http://${monero.rpc.address}:${toString monero.rpc.port}/get_info"
            ];
          }
        ];
      }
      (scrapeJob {
        name = "caddy";
        port = 2019;
        hosts = telemetryHosts;
        labels.service = "caddy";
      })
      (scrapeJob {
        name = "gotosocial";
        port = 2020;
        hosts = [ "jattelik" ];
        labels.service = "gotosocial";
      })
      (scrapeJob {
        name = "chrony";
        port = prom.exporters.chrony.port;
        hosts = telemetryHosts;
      })
      (scrapeJob {
        name = "smartctl";
        port = prom.exporters.smartctl.port;
        hosts = [
          "blahaj"
          "skogsduva"
        ];
      })
      (scrapeJob {
        name = "zfs";
        port = prom.exporters.zfs.port;
        hosts = telemetryHosts;
      })
      (scrapeJob {
        name = "kubo";
        port = 2021;
        hosts = [ "jattelik" ];
        labels.service = "ipfs";
      })
      (scrapeJob {
        name = "snowflake";
        port = 9999;
        hosts = [ "jattelik" ];
        labels.service = "snowflake";
        path = "/internal/metrics";
      })
    ];
  };

  services.caddy.virtualHosts."https://prometheus.natalia.ovh" = {
    logFormat = "output discard";
    extraConfig = ''
      import common

      bind [fd7a:115c:a1e0::ed01:8243] [::1]

      reverse_proxy ${prom.listenAddress}:${toString prom.port}
    '';
  };
}
