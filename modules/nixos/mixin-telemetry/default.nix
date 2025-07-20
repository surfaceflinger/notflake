_: {
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "drm"
      "ethtool"
      "qdisc"
      "wifi"
    ];
  };
}
