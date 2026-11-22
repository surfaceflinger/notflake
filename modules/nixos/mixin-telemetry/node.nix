_: {
  services.prometheus.exporters.node = {
    enable = true;
    # the zfs collector also exposes arcstats, which the kernel reports as
    # used memory and MemAvailable does not count
    enabledCollectors = [
      "drm"
      "ethtool"
      "qdisc"
      "wifi"
      "zfs"
    ];
  };
}
