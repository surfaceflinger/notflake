_: {
  nix-mineral = {
    extras.network.bluetooth-kmodules = true;
    settings = {
      kernel = {
        cpu-mitigations = "smt-on";
        pti = false;
        slab-debug = false;
      };
      system.multilib = true;
    };
    filesystems.normal = {
      "/home".options."noexec" = false;
      "/tmp".options."noexec" = false;
    };
  };
}
