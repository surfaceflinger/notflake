{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p -u -v";
    monthly = 2;
  };

  # fix unmounting /var/log (implicit zfs native mountpoint) on shutdown
  systemd.services.systemd-journal-flush = {
    before = [ "shutdown.target" ];
    conflicts = [ "shutdown.target" ];
  };
}
