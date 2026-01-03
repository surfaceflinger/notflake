{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.package = pkgs.zfs_2_4;
  };

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

  fileSystems = lib.genAttrs [ "/nix" "/etc/ssh" "/var/log" "/var/lib" ] (fs: {
    device = "${config.networking.hostName}/NixOS${lib.optionalString (fs != "/") fs}";
    fsType = "zfs";
    options = [ "zfsutil" ];
  });
}
