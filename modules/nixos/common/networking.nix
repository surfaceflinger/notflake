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
    dnsovertls = lib.warn "temporarily disabled DoT due to systemd 257.8 regression" "false";
    dnssec = "false"; # causes resolves to fail way too often
    llmnr = "false";
    extraConfig = ''
      Cache=no-negative
      MulticastDNS=false
      StaleRetentionSec=28800
    '';
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
    # bbr + cake
    "net.core.default_qdisc" = lib.mkForce "cake";
    "net.ipv4.tcp_congestion_control" = lib.mkForce "bbr";

    # nonlocal bind, helps some "race conditions" with services hosted on vpns etc.
    "net.ipv4.ip_nonlocal_bind" = 1;
    "net.ipv6.ip_nonlocal_bind" = 1;

    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_tw_reuse" = 1;
    "net.ipv4.tcp_fin_timeout" = 10;
    "net.ipv4.tcp_slow_start_after_idle" = 0;

    # keepalive
    "net.ipv4.tcp_keepalive_time" = 60;
    "net.ipv4.tcp_keepalive_intvl" = 10;
    "net.ipv4.tcp_keepalive_probes" = 6;

    # reenable few things disabled by hardening
    "net.ipv4.icmp_echo_ignore_all" = 0;
    "net.ipv4.tcp_dsack" = 1;
    "net.ipv4.tcp_sack" = 1;
    "net.ipv6.icmp.echo_ignore_all" = 0;
    "net.ipv6.icmp.echo_ignore_anycast" = 0;
    "net.ipv6.icmp.echo_ignore_multicast" = 0;

    # mtu probing
    "net.ipv4.tcp_mtu_probing" = 1;

    # random shit from k4yt3x
    "net.core.netdev_max_backlog" = 250000;
    "net.core.rmem_default" = 8388608;
    "net.core.wmem_default" = 8388608;
    "net.core.rmem_max" = 536870912;
    "net.core.wmem_max" = 536870912;
    "net.core.optmem_max" = 40960;
    "net.ipv4.tcp_synack_retries" = 5;
    "net.ipv4.ip_local_port_range" = "1024 65535";
    "net.ipv4.tcp_base_mss" = 1024;
    "net.ipv4.tcp_rmem" = "8192 262144 536870912";
    "net.ipv4.tcp_wmem" = "4096 16384 536870912";
    "net.ipv4.tcp_adv_win_scale" = "-2";
    "net.ipv4.tcp_notsent_lowat" = 131072;
  };
}
