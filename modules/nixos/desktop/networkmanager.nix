{ pkgs, ... }:
{
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openvpn ];
  };
  hardware.usb-modeswitch.enable = true;
}
