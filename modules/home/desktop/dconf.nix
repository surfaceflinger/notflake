{ lib, ... }:
with lib.hm.gvariant;
{
  dconf.settings = {
    # gnome
    "org/gnome/desktop/app-folders" = {
      folder-children = [ "" ];
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
      experimental-features = [ "variable-refresh-rate" ];
      workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      resize-with-right-button = true;
    };

    "org/gnome/GWeather4" = {
      temperature-unit = "centigrade";
    };

    "org/gnome/shell/weather" = {
      automatic-location = false;
    };

    "org/gnome/shell" = {
      disable-extension-version-validation = true;
      app-picker-layout = [ "" ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "com.mitchellh.ghostty.desktop"
        "Schizofox.desktop"
        "org.telegram.desktop.desktop"
        "vesktop.desktop"
        "slack.desktop"
        "org.gnome.Fractal.desktop"
        "org.squidowl.halloy.desktop"
        "dev.geopjr.Tuba.desktop"
        "timedoctor-desktop.desktop"
        "org.gnome.Geary.desktop"
        "io.bassi.Amberol.desktop"
        "io.github.htkhiem.Euphonica.desktop"
        "code.desktop"
        "io.gitlab.news_flash.NewsFlash.desktop"
        "org.prismlauncher.PrismLauncher.desktop"
        "lunarclient.desktop"
        "steam.desktop"
        "com.saivert.pwvucontrol.desktop"
        "org.pulseaudio.pavucontrol.desktop"
        "com.github.wwmm.easyeffects.desktop"
        "virt-manager.desktop"
        "de.haeckerfelix.Fragments.desktop"
        "org.qbittorrent.qBittorrent.desktop"
        "bitwarden.desktop"
      ];
      welcome-dialog-last-shown-version = "999";
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    # interface/theming
    "org/gnome/desktop/interface" = {
      accent-color = "pink";
      clock-show-weekday = true;
      document-font-name = "Merriweather 11";
      font-hinting = "none";
      font-name = "Nokia Sans 11";
      gtk-enable-primary-paste = false;
      gtk-theme = "adw-gtk3";
      monospace-font-name = "Cascadia Mono PL 10";
      show-battery-percentage = true;
    };

    "org/gnome/shell/extensions/user-theme-x" = {
      gtk = true;
      style = true;
      light-gtk = "adw-gtk3";
      light-style = "prefer-light";
      dark-gtk = "adw-gtk3-dark";
      dark-style = "prefer-dark";
    };

    # file portals
    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
    };

    "org/gtk/settings/file-chooser" = {
      show-hidden = true;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
    };

    # m/kb
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      disable-while-typing = false;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [
        (mkTuple [
          "xkb"
          "pl"
        ])
      ];
    };

    # hotkeys
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
      mic-mute = [ "<Control>m" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>r";
      command = "ghostty";
      name = "Start terminal";
    };

    # night light
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
    };

    "org/gnome/system/location" = {
      enabled = true;
    };

    # power management
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "nothing";
      sleep-inactive-ac-timeout = 1200;
      sleep-inactive-ac-type = "suspend";
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 300;
    };

    # temporary files
    "org/gnome/desktop/privacy" = {
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
      remove-old-temp-files = true;
      remove-old-trash-files = true;
    };

    # extensions
    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list = [
        "bitwarden.desktop:1"
        "org.telegram.desktop.desktop:1"
        "vesktop.desktop:1"
        "Schizofox.desktop:2"
        "lunarclient.desktop:3"
        "org.prismlauncher.PrismLauncher.desktop:3"
        "slack.desktop:3"
        "timedoctor-desktop.desktop:3"
        "steam.desktop:4"
      ];
    };

    "org/gnome/shell/extensions/appindicator" = {
      icon-saturation = 1.0;
    };

    "org/gnome/shell/extensions/gamemodeshellextension" = {
      show-icon-only-when-active = true;
      show-launch-notification = false;
    };

    "org/gnome/shell/extensions/pip-on-top" = {
      stick = true;
    };

    # random other gnome stuff
    "org/gnome/desktop/media-handling" = {
      autorun-never = true;
    };

    "org/gnome/desktop/notifications" = {
      show-in-lock-screen = false;
    };

    # virt-manager
    "org/virt-manager/virt-manager" = {
      xmleditor-enabled = true;
    };

    "org/virt-manager/virt-manager/console" = {
      auto-redirect = false;
    };

    "org/virt-manager/virt-manager/new-vm" = {
      cpu-default = "host-passthrough";
      firmware = "uefi";
      graphics-type = "system";
    };

    # random other software
    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gnome/TextEditor" = {
      discover-settings = true;
      highlight-current-line = true;
      indent-style = "space";
      restore-session = false;
      show-line-numbers = true;
      tab-width = mkUint32 2;
      wrap-text = false;
    };

    "org/gnome/gitlab/cheywood/Buffer" = {
      font-size = 10;
    };

    "com/saivert/pwvucontrol" = {
      enable-overamplification = true;
      use-peakmeter-led = true;
    };
  };
}
