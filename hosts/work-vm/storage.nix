_: {
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
  networking.hostId = "e5ef2880";

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
    device = "work-vm/NixOS/nix";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/etc/ssh" = {
    device = "work-vm/NixOS/etc/ssh";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1A60-B111";
    fsType = "vfat";
  };
}
