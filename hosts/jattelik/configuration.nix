{ nixosModules, pkgs, ... }:
{
  imports = [
    ./blahaj.pl/copyparty.nix
    ./blahaj.pl/gotosocial.nix
    ./blahaj.pl/wastebin.nix
    ./blahaj.pl/www.nix
    ./litestream.nix
    nixosModules.common
    nixosModules.mixin-telemetry
    nixosModules.mixin-vm
    nixosModules.mixin-www
    nixosModules.server
    nixosModules.user-nat
    ./personal/ipfs.nix
    ./personal/soju.nix
    ./personal/spacebot.nix
    ./personal/vaultwarden.nix
    ./storage.nix
    ./www.nix
  ];

  boot.initrd.availableKernelModules = [
    "sr_mod"
    "virtio_scsi"
  ];

  # base
  nixpkgs.hostPlatform = "aarch64-linux";

  # netcup doesn't provide dhcp
  # and their metadata service bugs cloud-init out.
  systemd.network.networks."1-wan" = {
    matchConfig.Name = "enp7s0";
    address = [
      "2a0a:4cc0:80:41c1::1/64"
      "152.53.113.46/22"
    ];
    routes = [
      { Gateway = "fe80::1"; }
      { Gateway = "152.53.112.2"; }
    ];
    # make the routes on this interface a dependency for network-online.target
    linkConfig.RequiredForOnline = "routable";
    # queue
    cakeConfig = {
      Bandwidth = "2500M";
      PriorityQueueingPreset = "besteffort";
    };
  };

  # tor snowflake proxy
  services.snowflake-proxy = {
    enable = true;
    capacity = 100;
  };

  # other software
  environment.systemPackages = with pkgs; [ archisteamfarm ];

  # secrets
  age.secrets.googlebackup = {
    file = ../../secrets/googlebackup.age;
    mode = "500";
    owner = "nat";
  };
}
