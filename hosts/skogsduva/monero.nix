{ config, inputs, ... }:
let
  i2p_address = "127.0.0.1";
  i2p_port = 37189;
in
{
  networking.firewall.allowedTCPPorts = [ 18080 ];

  services.monero = {
    enable = true;
    banlist = "${inputs.monero-banlist.result}/block.txt";
    rpc = {
      address = "0.0.0.0";
      port = 18089;
      restricted = true;
    };
    limits = {
      download = 1024;
      upload = 1048576;
    };
    extraConfig = ''
      confirm-external-bind=1
      db-sync-mode=safe
      enforce-dns-checkpointing=1
      no-igd=1
      p2p-use-ipv6=1
      prune-blockchain=1
      rpc-bind-ipv6-address=::
      rpc-use-ipv6=1
      tx-proxy=i2p,${i2p_address}:${toString i2p_port}
    '';
  };

  services.i2pd = {
    enable = true;
    upnp = {
      enable = true;
      name = "I2Pd ${config.networking.hostName}";
    };
    proto.socksProxy = {
      enable = true;
      address = i2p_address;
      port = i2p_port;
    };
  };
}
