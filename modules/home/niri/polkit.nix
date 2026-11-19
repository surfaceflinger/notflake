{ config, ... }:
let
  c = config.lib.stylix.colors.withHashtag;
  argb = color: "0xFF" + builtins.substring 1 6 color;
in
{
  services.hyprpolkitagent.enable = true;

  xdg.configFile."hypr/hyprtoolkit.conf".text = ''
    background = ${argb c.base00}
    base = ${argb c.base01}
    alternate_base = ${argb c.base02}
    text = ${argb c.base05}
    bright_text = ${argb c.base06}
    link_text = ${argb c.base0D}
    accent = ${argb c.base0D}
    accent_secondary = ${argb c.base0E}
    rounding_large = 12
    rounding_small = 6
    font_family = ${config.stylix.fonts.sansSerif.name}
    font_family_monospace = ${config.stylix.fonts.monospace.name}
  '';
}
