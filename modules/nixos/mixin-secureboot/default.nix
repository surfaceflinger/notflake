{ lib, pkgs, ... }: {
  boot.loader.limine = {
    # secure boot requires the editor off, while common/boot.nix turns it on
    enableEditor = lib.mkForce false;

    secureBoot = {
      enable = true;
      autoGenerateKeys = true;
    };

    # PCR 8/9 measurements of cmdline, kernel, initrd and limine.conf
    extraConfig = "measured_boot: yes";
  };

  environment.systemPackages = [ pkgs.sbctl ];
}
