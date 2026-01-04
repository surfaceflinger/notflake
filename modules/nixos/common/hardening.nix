{ inputs, lib, ... }:
{
  imports = [ inputs.nix-mineral.result.nixosModules.nix-mineral ];

  nix-mineral = {
    enable = true;
    preset = "maximum";
    settings = {
      debug.debugfs = true;
      etc.kicksecure-gitconfig = false;
      system.yama = "relaxed";
      kernel = {
        cpu-mitigations = "smt-on";
        lockdown = false;
        only-signed-modules = false;
        pti = false;
      };
      network = {
        icmp.ignore-all = false;
        ip-forwarding = true;
        max-addresses = false;
      };
    };
    extras = {
      entropy.extra-latent-entropy = true;
      network.tcp-window-scaling = true;
      system.minimize-swapping = false;
      misc = {
        ssh-hardening = true;
        usbguard.enable = false;
      };
    };
    filesystems.special."/proc".options.hidepid = lib.mkForce false;
  };

  # not included in nix-mineral
  boot.kernel.sysctl = {
    "dev.tty.legacy_tiocsti" = 0;
    "kernel.oops_limit" = 100;
    "kernel.warn_limit" = 100;
  };

  boot.kernelParams = [
    "bdev_allow_write_mounted=0"
    "debugfs=on" # reenable debugfs for some weird drivers and eg. rasdaemon
    "hash_pointers=always"
    "proc_mem.force_override=never"
  ];

  # better doas
  security.doas.extraRules = [
    {
      users = [ "root" ];
      groups = [ "wheel" ];
      keepEnv = true;
      persist = true;
    }
  ];

  # fixup for building
  services.logrotate.checkConfig = false;
}
