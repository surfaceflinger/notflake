{ pkgs, ... }: {
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openvpn ];
    wifi.backend = "iwd";
  };
  hardware.usb-modeswitch.enable = true;
}
