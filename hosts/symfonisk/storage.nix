_: {
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "978a106b";

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "defaults"
      "size=1G"
      "mode=755"
    ];
  };

  fileSystems."/nix" = {
    device = "symfonisk/NixOS/nix";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/etc/ssh" = {
    device = "symfonisk/NixOS/etc/ssh";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/persist" = {
    device = "symfonisk/NixOS/persist";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partuuid/98b5fda4-9c20-4049-90ac-18be204ba828";
    fsType = "vfat";
  };
}
