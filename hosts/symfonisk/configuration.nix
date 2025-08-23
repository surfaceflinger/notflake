{ inputs, nixosModules, ... }:
{
  imports = [
    "${inputs.nixos-hardware.result}/common/pc"
    "${inputs.nixos-hardware.result}/common/pc/ssd"
    ../../modules/nixos/desktop/networking.nix
    ../../modules/nixos/desktop/pipewire.nix
    ./mopidy.nix
    nixosModules.common
    nixosModules.mixin-telemetry
    nixosModules.mixin-www
    nixosModules.server
    nixosModules.user-nat
    ./storage.nix
  ];

  # base
  nixpkgs.hostPlatform = "x86_64-linux";

  # bootloader/kernel/modules
  hardware.enableRedistributableFirmware = true;
  boot = {
    loader.limine = {
      biosDevice = "/dev/sda";
      biosSupport = true;
    };
    initrd.availableKernelModules = [
      "ehci_pci"
      "pata_via"
      "sd_mod"
      "uhci_hcd"
      "usbhid"
      "usb_storage"
    ];
    kernelModules = [ "kvm-intel" ];
  };
  # some mitigations arent available on via eden x2 so its pointless
  # also its literally just a music streamer
  nix-mineral.overrides.performance.no-mitigations = true;

  # allow suspend
  services.logind = {
    powerKeyLongPress = "poweroff";
    powerKey = "suspend";
  };
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
  '';
}
