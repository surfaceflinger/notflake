_: {
  services = {
    tuned = {
      enable = true;
      ppdSettings.profiles = {
        power-saver = "powersave";
        balanced = "desktop";
        performance = "latency-performance";
      };
    };
  };
}
