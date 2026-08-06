{ inputs, lib, ... }: {
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
      network = {
        icmp.ignore-all = false;
        ip-forwarding = true;
        max-addresses = false;
        tcp-sack = true;
      };
    };
    extras = {
      entropy.extra-latent-entropy = true;
      misc.ssh-hardening = true;
      network.tcp-window-scaling = true;
      system.minimize-swapping = false;
      kernel = {
        load-kernel-modules = true;
        warn-panic = false;
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
    "tsx=auto"
  ];

  # fixup for building
  services.logrotate.checkConfig = false;
}
