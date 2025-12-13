_: {
  networking.hostId = "17c1a92a";

  boot.zfs.extraPools = [ "skogsduva-media" ];

  fileSystems."/boot".device = "/dev/disk/by-partuuid/dc5ef06b-ea2e-4c74-b108-bb09c0aefe9d";
}
