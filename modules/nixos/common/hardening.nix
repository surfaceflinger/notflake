{ inputs, lib, ... }:
{
  imports = [ inputs.nix-mineral.result.nixosModules.nix-mineral ];

  nix-mineral = {
    enable = true;
    preset = "maximum";
    settings = {
      debug.debugfs = true;
      etc.kicksecure-gitconfig = false;
      system = {
        proc-mem-force = "ptrace";
        yama = "relaxed";
      };
      kernel = {
        lockdown = false;
        only-signed-modules = false;
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
    filesystems = {
      special."/proc".options.hidepid = lib.mkForce false;
      normal = {
        "/home".options."bind" = false;
        "/srv".enable = lib.mkForce false;
        "/var/log".options."bind" = false;
      };
    };
  };

  boot.kernelParams = [
    "debugfs=on"
    "hardened_usercopy=1"
    "tsx=auto"
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
