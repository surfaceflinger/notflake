{ pkgs, ... }:
{
  services.easyeffects.enable = true;

  xdg.configFile = {
    "easyeffects/irs/google-pixel-buds-pro-autoeq.irs".source = pkgs.fetchurl {
      url = "https://github.com/jaakkopasanen/AutoEq/raw/3.0.0/results/Rtings/in-ear/Google%20Pixel%20Buds%20Pro/Google%20Pixel%20Buds%20Pro%20minimum%20phase%2048000Hz.wav";
      hash = "sha256-Oh4+QegYb2W1uWUTiBPOT95VOSyhFT/QSRahNxGDONs=";
    };

    "easyeffects/irs/sennheiser-hd-599-autoeq.irs".source = ./eq/hd599.wav;
    "easyeffects/irs/moondrop-u2-autoeq.irs".source = ./eq/moondropu2.wav;
  };
}
