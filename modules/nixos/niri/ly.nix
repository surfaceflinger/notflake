_: {
  services = {
    kmscon.enable = true;

    displayManager.ly = {
      enable = true;
      x11Support = false;
    };
  };

  systemd.tmpfiles.rules = [ "d /etc/ly/custom-sessions 0755 root root -" ];
}
