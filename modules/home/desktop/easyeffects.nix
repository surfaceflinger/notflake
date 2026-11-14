{ pkgs, ... }: {
  services.easyeffects.enable = true;

  xdg.dataFile = {
    "easyeffects/irs/apple-earpods-autoeq.irs".source = pkgs.fetchurl {
      url = "https://github.com/jaakkopasanen/AutoEq/raw/4.1.2/results/Rtings/earbud/Apple%20EarPods/Apple%20EarPods%20minimum%20phase%2048000Hz.wav";
      hash = "sha256-0ull5vN/Jv+dc+6jNVAWU/Ki5r94wi61NdsOW2Ju5Ek=";
    };

    "easyeffects/irs/google-pixel-buds-pro-autoeq.irs".source = pkgs.fetchurl {
      url = "https://github.com/jaakkopasanen/AutoEq/raw/4.1.2/results/Rtings/in-ear/Google%20Pixel%20Buds%20Pro/Google%20Pixel%20Buds%20Pro%20minimum%20phase%2048000Hz.wav";
      hash = "sha256-igbwgieL0nRLEfD2sSk5uxPIhsh7ddkfRcYhuPyP6pk=";
    };

    "easyeffects/irs/sennheiser-hd-599-autoeq.irs".source = pkgs.fetchurl {
      url = "https://github.com/jaakkopasanen/AutoEq/raw/4.1.2/results/oratory1990/over-ear/Sennheiser%20HD%20599/Sennheiser%20HD%20599%20minimum%20phase%2048000Hz.wav";
      hash = "sha256-FZx73qMJxq2sCOC77GTzgylNB+nMg3Dgx0wIRSqAAlI=";
    };
    "easyeffects/irs/moondrop-u2-autoeq.irs".source = ./eq/moondropu2.wav;
  };
}
