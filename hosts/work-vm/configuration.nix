{ nixosModules, ... }:
{
  imports = [
    nixosModules.common
    nixosModules.desktop
    nixosModules.mixin-tpm20
    nixosModules.mixin-vm
    nixosModules.user-natwork
    ./storage.nix
  ];

  # base
  nixpkgs.hostPlatform = "x86_64-linux";

  # bootloader/kernel/modules
  boot.initrd.availableKernelModules = [
    "ahci"
    "sr_mod"
    "xhci_pci"
  ];

  users.users.natwork.extraGroups = [ "wheel" ];
}
