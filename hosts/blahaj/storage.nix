_: {
  networking.hostId = "b84cacfe";

  boot.zfs.extraPools = [
    "smolhaj"
    "ikea"
  ];

  fileSystems."/boot".device = "/dev/disk/by-partlabel/blahajEFI";

  systemd.tmpfiles.rules = [ "d /vol/Games 0700 nat users - -" ];
}
