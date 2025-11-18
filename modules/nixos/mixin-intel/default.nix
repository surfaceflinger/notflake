{ config, ... }:
{
  # base
  nixpkgs.hostPlatform = "x86_64-linux";

  # kernel/modules/firmware
  hardware.enableRedistributableFirmware = true;
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.zenergy ];
    kernelModules = [ "kvm-intel" ];
  };

  # misc
  services.hardware.openrgb.motherboard = "intel";
  services.thermald.enable = true;
}
