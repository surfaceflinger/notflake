{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./agenix.nix
    ./boot.nix
    ./chrony.nix
    ./doas.nix
    ./hardening.nix
    inputs.home-manager.result.nixosModules.default
    ./memory.nix
    ./nano.nix
    ./networking.nix
    ./nix.nix
    ./regional.nix
    ./system-packages.nix
    ./zfs.nix
    ./zsh.nix
  ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_hardened;

  # override srvos changes
  programs.vim.defaultEditor = false;

  # configure cloud-init (enabled where needed)
  systemd.tmpfiles.rules = [ "R /var/lib/cloud" ];
  services.cloud-init.settings = {
    random_seed.file = "/dev/null";
  };

  # reliability, availability and serviceability
  hardware.rasdaemon.enable = true;

  # openssh everywhere
  services.openssh.enable = true;

  # enable scx
  services.scx = {
    enable = !pkgs.stdenv.isAarch64;
    package = pkgs.scx.rustscheds;
    scheduler = "scx_bpfland";
  };

  # configure home-manager
  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true; # don't create another instance of nixpkgs
    useUserPackages = true; # install user packages directly to the user's profile
    extraSpecialArgs = {
      inherit inputs; # forward the inputs
    };
  };
}
