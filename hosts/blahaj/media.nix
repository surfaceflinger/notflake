{ config, ... }:
{
  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      inotify = "yes";
      media_dir = [ "V,/vol/ikea/Media/Videos/" ];
      friendly_name = config.networking.hostName;
    };
  };

  services.caddy.virtualHosts.":9090".extraConfig = ''
    root * /vol/ikea/Media/Videos/
    file_server browse
  '';
  networking.firewall.allowedTCPPorts = [ 9090 ];

  # allow both darkhttpd and minidlna to see media files.
  systemd.tmpfiles.rules = [
    "d /vol/ikea 0755 nat root - -"
    "d /vol/ikea/Media 0755 nat root - -"
    "d /vol/ikea/Media/Videos 0755 nat root - -"
  ];
}
