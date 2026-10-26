{
  inputs,
  lib,
  nixosModules,
  ...
}:
{
  imports = [
    "${inputs.nixos-hardware.result}/common/pc/ssd"
    "${inputs.nixos-hardware.result}/lenovo/thinkpad/t440p"
    nixosModules.common
    nixosModules.desktop-env
    nixosModules.laptop
    nixosModules.mixin-bdprochot
    nixosModules.mixin-gaming
    nixosModules.mixin-intel
    nixosModules.mixin-secureboot
    nixosModules.user-nat
    ./storage.nix
  ];

  # bootloader/kernel/modules
  boot.initrd.availableKernelModules = [
    "ahci"
    "ehci_pci"
    "rtsx_pci_sdmmc"
    "sd_mod"
    "sr_mod"
    "usb_storage"
    "xhci_pci"
  ];

  services.fwupd.enable = true;

  # make fan silent
  services.zcfan.enable = true;

  # aspm causes issues on this host
  services.autoaspm.enable = lib.mkForce false;

  # disable these fucking pgup/pgdown around arrow up - who came up with this?
  services.keyd = {
    enable = true;
    keyboards."liteon" = {
      ids = [ "0001:0001" ];
      settings.main = {
        pageup = "noop";
        pagedown = "noop";
      };
    };
  };
}
