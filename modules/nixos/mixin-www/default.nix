_: {
  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
      80
      443
    ];
  };

  services.caddy = {
    enable = true;
    email = "ssl@nekopon.pl";
    enableReload = false;
    globalConfig = ''
      admin off
      metrics { per_host }
    '';
    virtualHosts.":2019" = {
      logFormat = "output discard";
      extraConfig = "route /metrics { metrics }";
    };
  };
}
