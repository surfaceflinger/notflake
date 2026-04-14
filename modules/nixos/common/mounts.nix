{ config, lib, ... }:
{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };

    "/boot".fsType = "vfat";
  }
  // lib.genAttrs [ "/etc" "/root" "/tmp" "/var" "/var/tmp" ] (_: {
    fsType = "none";
  })
  // lib.genAttrs [ "/nix" "/etc/ssh" "/home" "/var/log" "/var/lib" ] (fs: {
    device = "${config.networking.hostName}/NixOS${lib.optionalString (fs != "/") fs}";
    fsType = "zfs";
    options = [ "zfsutil" ];
  });
}
