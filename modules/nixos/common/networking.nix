{
  config,
  lib,
  pkgs,
  ...
}:
{
  # enable dhcp on all physical ethernet interfaces
  systemd.network.networks."10-eth-dhcp" =
    lib.mkIf (!(config.services.cloud-init.enable && config.services.cloud-init.network.enable))
      {
        # match every ether type
        matchConfig.Type = "ether";
        # these are usually managed by vpns, hypervisors etc.
        matchConfig.Driver = "!tun";
        matchConfig.Name = "!veth* !vnet*";
        # enable dhcp and routing
        networkConfig = {
          DHCP = true;
          Domains = [ "~lan" ];
          IPv4Forwarding = true;
          IPv6AcceptRA = false;
          IPv6Forwarding = true;
        };
        dhcpV6Config.WithoutRA = "solicit";
      };

  # dns
  networking.nameservers = [
    "149.112.112.11#dns11.quad9.net"
    "2620:fe::11#dns11.quad9.net"
    "2620:fe::fe:11#dns11.quad9.net"
    "9.9.9.11#dns11.quad9.net"
  ];

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSOverTLS = "opportunistic";
      DNSSEC = "false"; # true causes resolves to fail way too often
      LLMNR = "false";
      MulticastDNS = "false";
    };
  };

  # tailscale
  networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "both";
    extraDaemonFlags = [ "--no-logs-no-support" ];
  };

  ## https://github.com/tailscale/tailscale/issues/8223
  systemd.services."whytailscalewhy" = {
    description = "Tailscale restart on resume";
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.target" ];
    script = ''
      . /etc/profile;
      ${pkgs.systemd}/bin/systemctl restart tailscaled.service
    '';
    serviceConfig.Type = "oneshot";
  };

  # kernel tuning
  boot.kernel.sysctl = {
    # nonlocal bind, helps some "race conditions" with services hosted on vpns etc.
    "net.ipv4.ip_nonlocal_bind" = 1;
    "net.ipv6.ip_nonlocal_bind" = 1;

    # keepalive
    "net.ipv4.tcp_keepalive_time" = 120;
    "net.ipv4.tcp_keepalive_intvl" = 30;
    "net.ipv4.tcp_keepalive_probes" = 4;

    # mtu probing
    "net.ipv4.tcp_mtu_probing" = 1;

    # random shit from k4yt3x and others
    #"net.core.netdev_max_backlog" = 250000;
    "net.core.rmem_default" = 26214400;
    "net.core.rmem_max" = 26214400;
    "net.core.wmem_default" = 26214400;
    "net.core.wmem_max" = 26214400;
    "net.ipv4.ip_local_port_range" = "1024 65535";
    "net.ipv4.tcp_adv_win_scale" = "-2";
    "net.ipv4.tcp_ecn" = 1;
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_notsent_lowat" = 131072;
    "net.ipv4.tcp_rmem" = "4096	1000000	16000000";
    "net.ipv4.tcp_wmem" = "4096	1000000	16000000";
  };
}
