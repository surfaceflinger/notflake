{ config, pkgs, ... }:
let
  c = config.lib.stylix.colors.withHashtag;
in
{
  home.packages = [ pkgs.raffi ];

  xdg.configFile."raffi/raffi.yaml".source = (pkgs.formats.yaml { }).generate "raffi.yaml" {
    version = 1;

    general = {
      theme = "dark";
      font_family = config.stylix.fonts.sansSerif.name;
      opacity = 0.95;
      raise_running = true;
      preview.mono_font_family = config.stylix.fonts.monospace.name;
      theme_colors = {
        bg_base = c.base00;
        bg_input = c.base01;
        accent = c.base0D;
        accent_hover = c.base0E;
        text_main = c.base05;
        text_muted = c.base04;
        selection_bg = c.base02;
        border = c.base02;
      };
    };

    addons = {
      audio.enabled = false; # ashell handles audio switching
      bitwarden.enabled = false;
      browser_history.enabled = false;
      browser_tabs.enabled = false;
      clipboard.enabled = false; # no cache daemon
      emoji.enabled = false;
      pass.enabled = false;
      slack.enabled = false;
      system.enabled = false; # loginctl lock-session is a no-op under niri
      terminal.enabled = false;
    };
  };
}
