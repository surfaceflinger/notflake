_: {
  users.users.caddy.extraGroups = [ "ipfs" ];
  users.users.nat.extraGroups = [ "ipfs" ];

  services.kubo = {
    enable = true;
    localDiscovery = false;
    enableGC = true;
    settings = {
      Datastore = {
        GCPeriod = "12h";
        StorageMax = "30GB";
      };
      Discovery.MDNS.Enabled = false;
      Plugins.Plugins.telemetry.Config.Mode = "off";
      Provide = {
        DHT.SweepEnabled = true;
        Strategy = "pinned";
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 4001 ];
    allowedUDPPorts = [ 4001 ];
  };

  # the api has no tcp listener, proxy its prometheus endpoint for scraping
  services.caddy.virtualHosts.":2021" = {
    logFormat = "output discard";
    extraConfig = ''
      route /metrics {
        rewrite * /debug/metrics/prometheus
        reverse_proxy unix//run/ipfs.sock
      }
    '';
  };
}
