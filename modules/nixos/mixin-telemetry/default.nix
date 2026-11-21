{
  imports = [ ./node.nix ];

  services.prometheus.exporters = {
    chrony.enable = true;
    smartctl.enable = true;
    zfs.enable = true;
  };
}
