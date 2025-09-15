_: {
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
  networking.hostId = "e5ef2880";

  fileSystems."/boot".device = "/dev/disk/by-uuid/1A60-B111";
}
