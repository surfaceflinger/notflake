_: {
  nix-mineral = {
    settings = {
      kernel = {
        cpu-mitigations = "smt-on";
        pti = false;
      };
      system.multilib = true;
    };
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
