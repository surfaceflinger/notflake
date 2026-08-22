{ lib, nixosModules, ... }: {
  imports = [ nixosModules.mixin-baremetal ];

  # base
  nixpkgs.hostPlatform = "x86_64-linux";

  # kernel/modules/firmware
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [ "kvm-intel" ];
  nix-mineral.kernel-modules.disable.intelme-related = lib.mkForce false;

  # misc
  services.hardware.openrgb.motherboard = "intel";
  services.thermald.enable = true;
}
