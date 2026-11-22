{
  config,
  lib,
  pkgs,
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

  # every target is also marked with the host it runs on, so panels can filter
  # node, zfs, smartctl and service metrics with the same $host variable
  hostLabel =
    host:
    lib.optionalAttrs (builtins.match "[A-Za-z0-9][A-Za-z0-9_.-]*" host != null) {
      inherit host;
    };

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
      static_configs = map (host: {
        targets = [ "${host}:${toString port}" ];
        labels = hostLabel host // labels;
      }) hosts;
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
    ruleFiles = [
      ((pkgs.formats.yaml { }).generate "recording-rules.yml" {
        groups = [
          {
            name = "memory";
            interval = "30s";
            rules = [
              {
                # ARC is reclaimable, so count all but its minimum as
                # available; hosts without ZFS fall back to MemAvailable
                record = "node:memory_available_with_arc_bytes";
                expr = "node_memory_MemAvailable_bytes + clamp_min(node_zfs_arc_size - node_zfs_arc_c_min, 0) or node_memory_MemAvailable_bytes";
              }
            ];
          }
        ];
      })
    ];
    scrapeConfigs = [
      (scrapeJob {
        name = "prometheus";
        port = prom.port;
        hosts = [ prom.listenAddress ];
        labels.host = config.networking.hostName;
      })
      (scrapeJob {
        name = "grafana";
        port = grafana.http_port;
        hosts = [ "[${grafana.http_addr}]" ];
        labels.host = config.networking.hostName;
      })
      {
        job_name = "node";
        static_configs = lib.concatMap (
          { role, targets }:
          map (host: {
            targets = [ "${host}:${toString nodePort}" ];
            labels = {
              inherit host role;
            };
          }) targets
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
        labels.host = config.networking.hostName;
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
            labels = {
              host = config.networking.hostName;
              service = "monero";
            };
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
