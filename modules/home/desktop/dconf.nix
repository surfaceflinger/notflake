{ lib, ... }: with lib.hm.gvariant;
{
  dconf.settings = {
    # the pile of settings gtk apps read regardless of the desktop
    "org/gnome/desktop/interface" = {
      accent-color = "pink";
      clock-show-weekday = true;
      cursor-size = 32; # native size of the pixel art miku cursors
      document-font-name = "Lora 11";
      font-hinting = "none";
      font-name = "Atkinson Hyperlegible Next 11";
      gtk-enable-primary-paste = false;
      gtk-theme = "adw-gtk3";
      monospace-font-name = "Cascadia Mono PL 10";
      show-battery-percentage = true;
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
