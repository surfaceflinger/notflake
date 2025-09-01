_: {
  services.chrony = {
    enable = true;
    enableNTS = true;
    extraFlags = [ "-F 1" ];
    enableRTCTrimming = false;
    extraConfig = ''
      authselectmode prefer
      cmdport 0
      dscp 46
      makestep 1.0 3
      minsources 3
      nocerttimecheck 1
      noclientlog
      rtconutc
      rtcsync
    '';
  };
  networking.timeServers = [
    "ntp.nanosrvr.cloud"
    "ptbtime1.ptb.de"
    "www.masters-of-cloud.de"
    "nts.ntstime.de"
    "ntp3.fau.de"
    "www.jabber-germany.de"
    "time.bolha.one"
    "gbg1.nts.netnod.se"
    "time.signorini.ch"
    "paris.time.system76.com"
    "time.txryan.com"
    "a.st1.ntp.br"
    "ntp.3eck.net"
    "ntp.zeitgitter.net"
    "ntp.miuku.net"
    "ntpmon.dcs1.biz"
    "stratum1.time.cifelli.xyz"
  ];
}
