{ config, pkgs, ... }:
let
  c = config.lib.stylix.colors.withHashtag;
  pair = color: [
    color
    color
  ];
in
{
  programs = {
    bluetuith = {
      enable = true;

      settings = {
        receive-dir = "${config.home.homeDirectory}/Downloads";
        confirm-on-quit = true;

        theme = {
          Text = c.base05;
          Border = c.base02;
          Background = c.base00;
          StatusInfo = c.base05;
          StatusError = c.base08;
          Adapter = c.base05;
          AdapterPowered = c.base0B;
          AdapterNotPowered = c.base08;
          AdapterDiscoverable = c.base0D;
          AdapterScanning = c.base09;
          AdapterPairable = c.base0D;
          Device = c.base05;
          DeviceType = c.base0E;
          DeviceAlias = c.base05;
          DeviceConnected = c.base0B;
          DeviceDiscovered = c.base09;
          DeviceProperty = c.base04;
          DevicePropertyConnected = c.base0B;
          DevicePropertyDiscovered = c.base09;
          Menu = c.base05;
          MenuBar = c.base01;
          MenuItem = c.base05;
          ProgressBar = c.base0D;
          ProgressText = c.base05;
        };
      };
    };

    wiremix = {
      enable = true;

      settings = {
        char_set = "compat";
        max_volume_percent = 150.0;
      };
    };
  };

  home.packages = [ pkgs.wifitui ];

  programs.ashell.settings.settings = {
    audio_sinks_more_cmd = "ghostty --class=ashell-tui -e wiremix";
    audio_sources_more_cmd = "ghostty --class=ashell-tui -e wiremix";
    wifi_more_cmd = "ghostty --class=ashell-tui -e wifitui --theme=$HOME/.config/wifitui/theme.toml";
    vpn_more_cmd = "ghostty --class=ashell-tui -e nmtui";
    bluetooth_more_cmd = "ghostty --class=ashell-tui -e bluetuith";
  };

  xdg.configFile."wifitui/theme.toml".source = (pkgs.formats.toml { }).generate "wifitui-theme" {
    Primary = pair c.base0D;
    Subtle = pair c.base04;
    Success = pair c.base0B;
    Error = pair c.base08;
    Normal = pair c.base05;
    Disabled = [
      c.base02
      c.base03
    ];
    Border = pair c.base02;
    SignalHigh = pair c.base0B;
    SignalLow = [
      c.base0A
      c.base09
    ];
    Saved = pair c.base0D;
  };
}
