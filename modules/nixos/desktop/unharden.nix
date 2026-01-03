_: {
  nix-mineral = {
    settings.system.multilib = true;
    extras = {
      network.bluetooth-kmodules = true;
      system.unprivileged-userns = true;
    };
    filesystems.normal = {
      "/home".options."noexec" = false;
      "/tmp".options."noexec" = false;
    };
  };
}
