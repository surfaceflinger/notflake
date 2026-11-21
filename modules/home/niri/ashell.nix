{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.ashell = {
    enable = true;

    settings = {
      layer = "Top";
      enable_esc_key = true;

      modules = {
        left = [ "Workspaces" ];
        center = [ "Tempo" ];
        right = [
          [
            "MediaPlayer"
            "Privacy"
            "Notifications"
            "Tray"
            "Settings"
          ]
        ];
      };

      workspaces = {
        visibility_mode = "MonitorSpecific";
        indicator_format = "NameAndIcons";
      };

      notifications = {
        toast_position = "TopCenter";
        grouped = true;
      };

      settings.indicators = [
        "IdleInhibitor"
        "PowerProfile"
        "Audio"
        "Microphone"
        "Bluetooth"
        "Network"
        "Vpn"
        "Battery"
        "Brightness"
        "PeripheralBattery"
      ];

      settings.lock_cmd = lib.getExe pkgs.hyprlock;
      # an explicit click should not be blocked by idle inhibitors
      settings.suspend_cmd = "${lib.getExe' pkgs.systemd "systemctl"} suspend --ignore-inhibitors";
      # loginctl kill-user leaves kmscon stuck on its notice screen after logout
      settings.logout_cmd = "niri msg action quit";
      # wiremix and the ashell OSD should allow the same overdrive
      settings.max_volume = 150;

      media_player.menu_visualizer = true;
      # a title in the bar widens the right group and pushes the clock off-center
      media_player.indicator_format = "Icon";

      tempo.weather_location = {
        City = "Warsaw";
      };
      tempo.weather_indicator = "None";

      osd = {
        enabled = true;
        show_volume_percentage = true;
        show_brightness_percentage = true;
      };

      animations.enabled = true;

      appearance = {
        font_name = config.stylix.fonts.sansSerif.name;
        blur = "always";

        # one step above each module's default (bar grows a little taller)
        modules = {
          workspaces.font_size = "sm";
          tempo.font_size = "lg";
          media_player.font_size = "lg";
          privacy.font_size = "lg";
          notifications.font_size = "lg";
          settings.font_size = "lg";
        };
        warning_color = config.lib.stylix.colors.withHashtag.base09;

        bar = {
          surface = "solid";
        };
      };
    };
  };

  # the media menu visualizer shells out to cava
  home.packages = [ pkgs.cava ];
}
