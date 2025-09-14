_: {
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "17c1a92a";

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
    device = "skogsduva/NixOS/nix";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/etc/ssh" = {
    device = "skogsduva/NixOS/etc/ssh";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partuuid/dc5ef06b-ea2e-4c74-b108-bb09c0aefe9d";
    fsType = "vfat";
  };
}
