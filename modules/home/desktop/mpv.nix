{ pkgs, ... }: {
  programs.mpv = {
    enable = true;
    scripts = with pkgs; [
      mpvScripts.inhibit-gnome
      mpvScripts.mpris
      mpvScripts.mpv-webm
      mpvScripts.quality-menu
      mpv-shader-stacks
    ];
    bindings = with pkgs; {
      # shader stacks
      "CTRL+s" = "script-binding shader_stacks/select";
      "CTRL+0" = ''no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"'';

      # quality-menu
      "Alt+f" = "script-binding quality_menu/audio_formats_toggle";
      "F" = "script-binding quality_menu/video_formats_toggle";
    };
    config = {
      # video
      "dither-depth" = 8;
      "profile" = "high-quality";
      "scale-antiring" = 0.6;
      "vo" = "gpu-next";

      # behavior
      "keep-open" = true;
      "save-position-on-quit" = true;

      # screenshots
      "screenshot-directory" = "~~desktop/Pictures/mpv/";
      "screenshot-format" = "png";
      "screenshot-template" = "%F-%p-%n";

      # langs
      "alang" = "jpn,ja";
      "slang" = "enm,eng,en";

      # misc
      "hwdec" = "auto-safe";
      "ytdl-format" =
        "bestvideo[height<=480][vcodec=avc1]+bestaudio/bestvideo[height<=480]+bestaudio/best[height<=480]/best";
    };
  };
}
