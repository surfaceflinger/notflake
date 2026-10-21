{ pkgs, ... }:
{
  services.chrony = {
    enable = true;
    # ntppool1 is a single server, but nixpkgs emits `pool` for any name
    # containing "pool"; it stays in extraConfig below.
    servers = [
      "time.cloudflare.com"
      "nts.netnod.se"
      "ptbtime1.ptb.de"
      "time.dfm.dk"
      "time.cifelli.xyz"
    ];
    serverOption = "iburst";
    enableNTS = true;
    extraFlags = [
      "-F 1"
      "-r"
    ];
    enableRTCTrimming = false;
    makestep = {
      threshold = 1.0;
      limit = 3;
    };
    extraConfig = ''
      server ntppool1.time.nl iburst nts

      minsources 3
      authselectmode require

      # EF
      dscp 46

      dumpdir /var/lib/chrony
      leapseclist ${pkgs.tzdata}/share/zoneinfo/leap-seconds.list

      rtcsync

      cmdport 0

      noclientlog
    '';
  };
}
