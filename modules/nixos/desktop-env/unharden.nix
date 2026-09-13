_: {
  nix-mineral = {
    kernel-modules.disable = {
      bluetooth-related = false;
      joystick-drivers = false;
    };
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
