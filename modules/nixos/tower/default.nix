_: {
  services = {
    tuned = {
      enable = true;
      ppdSettings = {
        battery = {
          power-saver = "powersave";
          balanced = "balanced-battery";
          performance = "latency-performance";
        };
        profiles = {
          power-saver = "powersave";
          balanced = "desktop";
          performance = "latency-performance";
        };
      };
    };
  };
}
