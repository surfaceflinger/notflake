{ config, ... }: {
  services.wpaperd = {
    enable = true;
    settings.default.path = "${config.home.homeDirectory}/Pictures/Wallpapers";
  };

  systemd.user.tmpfiles.rules = [ "d ${config.home.homeDirectory}/Pictures/Wallpapers 0755 - - -" ];
}
