_: {
  security.sudo.enable = false;

  security.run0 = {
    enable = true;
    sudo-shim.enable = true;
    persistentAuth.enable = true;
  };
}
