{ pkgs, ... }: {
  # other software
  environment.systemPackages = with pkgs; [
    # desktop software
    buffer
    ffmpegthumbnailer
    gnome-obfuscate
    metadata-cleaner
    papers

    # gtk theming, paired with modules/home/desktop/gtk.nix
    adw-gtk3
    morewaita-icon-theme

    # media
    ffmpeg-headless
    pinta
    yt-dlp

    # system utilities
    libva-utils
    mesa-demos
    (nvtopPackages.full.override { nvidia = false; })
    pwvucontrol
  ];
}
