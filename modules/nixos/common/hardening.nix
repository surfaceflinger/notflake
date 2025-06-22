{
  inputs,
  lib,
  ...
}:
{
  imports = [
    "${inputs.nix-mineral.result}/nix-mineral.nix"
  ];

  nix-mineral = {
    enable = true;
    overrides = {
      compatibility = {
        allow-ip-forward = true;
        allow-unsigned-modules = true;
        no-lockdown = true;
      };
      desktop.hideproc-off = true;
      performance.allow-smt = true;
      security = {
        disable-bluetooth-kmodules = true;
        disable-intelme-kmodules = true;
        lock-root = true;
      };
    };
  };

  environment.etc.gitconfig.text = lib.mkForce "";

  boot.kernel.sysctl = {
    "dev.tty.legacy_tiocsti" = 0;
    "kernel.unprivileged_userns_clone" = lib.mkDefault 0;
    "kernel.warn_limit" = 100;
  };

  boot.kernelParams = [
    "bdev_allow_write_mounted=0"
    "cfi=kcfi" # won't work anyway
    "debugfs=on" # reenable debugfs for some weird drivers and eg. rasdaemon
  ];

  # fixup for building
  services.logrotate.checkConfig = false;
}
