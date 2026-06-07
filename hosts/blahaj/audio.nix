{ pkgs, ... }: {
  services.pipewire = {
    extraConfig = {
      client."99-resample"."stream.properties"."resample.quality" = 10;
      pipewire."99-allowed-rates"."context.properties"."default.clock.allowed-rates" = [ 48000 ];
      pipewire-pulse."99-resample"."stream.properties"."resample.quality" = 10;
    };
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/main.lua.d/99-e205u.lua" ''
        table.insert(alsa_monitor.rules, {
            matches = {
                {
                    { "device.name", "matches", "alsa_card.usb-Superlux_digit_Superlux_E205U-00" },
                },
            },
            apply_properties = {
                ["api.alsa.soft-mixer"] = true,
            },
        })
      '')
    ];
  };
}
