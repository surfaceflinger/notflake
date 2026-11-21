_: {
  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [
        "drm"
        "ethtool"
        "qdisc"
        "wifi"
      ];
    };
    chrony.enable = true;
    smartctl.enable = true;
    zfs.enable = true;
  };
}
