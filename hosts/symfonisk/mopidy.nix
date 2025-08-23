{ pkgs, ... }:
{
  # pipewire
  environment.systemPackages = [ pkgs.wiremix ];
  security.rtkit.enable = true;
  services.pipewire = {
    alsa.enable = true;
    enable = true;
    pulse.enable = true;
    socketActivation = false;
    systemWide = true;
  };
  systemd.services = {
    pipewire-pulse.wantedBy = [ "default.target" ];
    pipewire.wantedBy = [ "default.target" ];
  };

  # mopidy
  networking.firewall.allowedTCPPorts = [
    6680
    8989
  ];
  services.mopidy = {
    enable = true;
    extensionPackages = [
      pkgs.mopidy-iris
      pkgs.mopidy-tidal
    ];
    configuration = ''
      [http]
      default_app = iris
      [tidal]
      enabled = true
      quality = LOSSLESS
    '';
  };
  users.users.mopidy.extraGroups = [ "pipewire" ];

  services.caddy.virtualHosts."symfonisk:443" = {
    extraConfig = ''
      import common
      tls internal
      reverse_proxy 127.0.0.1:6680
    '';
  };
}
