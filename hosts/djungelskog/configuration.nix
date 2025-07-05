{ inputs, nixosModules, ... }:
{
  imports = [
    "${inputs.nixos-hardware.result}/common/pc/ssd"
    "${inputs.nixos-hardware.result}/lenovo/thinkpad/t440p"
    nixosModules.common
    nixosModules.desktop
    nixosModules.laptop
    nixosModules.mixin-bdprochot
    nixosModules.mixin-gaming
    nixosModules.user-nat
    nixosModules.user-natwork
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
      "ahci"
      "ehci_pci"
      "rtsx_pci_sdmmc"
      "sd_mod"
      "sr_mod"
      "usb_storage"
      "xhci_pci"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  # power management
  boot.kernelParams = [ "intel_pstate=passive" ];
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
    CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
    START_CHARGE_THRESH_BAT0 = 85;
    STOP_CHARGE_THRESH_BAT0 = 90;
  };

  # thinkfan
  services.thinkfan = {
    enable = true;
    levels = [
      [
        0
        0
        65
      ]
      [
        1
        65
        75
      ]
      [
        3
        75
        80
      ]
      [
        7
        80
        90
      ]
      [
        "level disengaged"
        90
        32767
      ]
    ];
    sensors = [
      {
        query = "/sys/devices/platform/coretemp.0/hwmon/";
        indices = [
          1
          2
          3
          4
          5
        ];
        type = "hwmon";
      }
    ];
  };

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
