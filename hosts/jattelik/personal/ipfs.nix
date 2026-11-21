_: {
  users.users.nat.extraGroups = [ "ipfs" ];

  services.kubo = {
    enable = true;
    localDiscovery = false;
    enableGC = true;
    settings = {
      Adresses.API = [ ];
      Discovery.MDNS.Enabled = false;
      Plugins.Plugins.telemetry.Config.Mode = "off";
      Provide.DHT.SweepEnabled = true;
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
