_: {
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "b84cacfe";

  boot.zfs.extraPools = [
    "smolhaj"
    "ikea"
  ];

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
    device = "blahaj/NixOS/nix";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/etc/ssh" = {
    device = "blahaj/NixOS/etc/ssh";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/persist" = {
    device = "blahaj/NixOS/persist";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/blahajEFI";
    fsType = "vfat";
  };

  systemd.tmpfiles.rules = [ "d /vol/Games 0700 nat users - -" ];
}
