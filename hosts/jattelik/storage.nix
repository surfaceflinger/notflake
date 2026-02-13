_: {
  networking.hostId = "0f8a54ac";
  boot.zfs.devNodes = "/dev/disk/by-partuuid";

  fileSystems."/boot".device = "/dev/vda1";

  fileSystems."/srv/fileshare" = {
    device = "jattelik/srv/fileshare";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
}
