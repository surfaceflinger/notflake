{ pkgs, ... }:
{
  users.groups.music = { };
  systemd.services = {
    slimserver.serviceConfig.Group = "music";
  };

  services.slimserver = {
    enable = true;
    package = pkgs.slimserver.override { enableUnfreeFirmware = true; };
  };

  networking.firewall = {
    allowedTCPPorts = [
      3483
      9000
      9090
      31337
    ];
    allowedUDPPorts = [ 3483 ];
  };
}
