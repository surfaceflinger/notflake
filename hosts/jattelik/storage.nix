_: {
  networking.hostId = "0f8a54ac";
  boot.zfs.devNodes = "/dev/disk/by-partuuid";

  fileSystems."/boot".device = "/dev/vda1";
}
