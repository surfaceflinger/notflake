_: {
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "1f1050fa";

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "defaults"
      "size=2G"
      "mode=755"
    ];
  };

  fileSystems."/nix" = {
    device = "sjorapport/NixOS/nix";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/etc/ssh" = {
    device = "sjorapport/NixOS/etc/ssh";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9249-C4FB";
    fsType = "vfat";
  };
}
