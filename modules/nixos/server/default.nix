{ inputs, ... }:
{
  imports = [ "${inputs.srvos.result}/nixos/server" ];

  services.prometheus.exporters.node.enabledCollectors = [
    "processes"
    "systemd"
  ];
}
