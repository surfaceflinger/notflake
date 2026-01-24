{ pkgs, ... }:
{
  # other software
  environment.systemPackages = with pkgs; [
    # desktop software
    buffer
    gnome-obfuscate
    metadata-cleaner
    papers

    # media
    ffmpeg-full
    krita
    yt-dlp

    # system utilities
    libva-utils
    mesa-demos
    (nvtopPackages.full.override { nvidia = false; })
    pwvucontrol
  ];
}
