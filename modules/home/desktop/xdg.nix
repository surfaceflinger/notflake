_:
let
  archives = [ "org.gnome.FileRoller.desktop" ];
  browser = [ "Schizofox.desktop" ];
  docs = [ "org.gnome.Papers.desktop" ];
  files = [ "org.gnome.Nautilus.desktop" ];
  media = [ "mpv.desktop" ];
  photos = [ "org.gnome.Loupe.desktop" ];
  steam = [ "steam.desktop" ];
  text = [ "org.gnome.TextEditor.desktop" ];
  torrents = [ "de.haeckerfelix.Fragments.desktop" ];

  associations = {
    # misc
    "application/json" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/xhtml+xml" = browser;
    "inode/directory" = files;
    "text/html" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = browser;

    # apps
    "application/x-bittorrent" = torrents;
    "x-scheme-handler/discord" = [ "vesktop.desktop" ];
    "x-scheme-handler/magnet" = torrents;
    "x-scheme-handler/slack" = [ "slack.desktop" ];
    "x-scheme-handler/steamlink" = steam;
    "x-scheme-handler/steam" = steam;
    "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];

    # archives
    "application/gzip" = archives;
    "application/vnd.rar" = archives;
    "application/x-7z-compressed" = archives;
    "application/x-compressed-tar" = archives;
    "application/x-tar" = archives;
    "application/x-xz" = archives;
    "application/zip" = archives;
    "application/zstd" = archives;

    # audio formats
    "audio/aac" = media;
    "audio/aiff" = media;
    "audio/flac" = media;
    "audio/mp3" = media;
    "audio/mp4" = media;
    "audio/mpeg" = media;
    "audio/mpegurl" = media;
    "audio/ogg" = media;
    "audio/opus" = media;
    "audio/wav" = media;
    "audio/webm" = media;
    "audio/x-aac" = media;
    "audio/x-aiff" = media;
    "audio/x-flac" = media;
    "audio/x-m4a" = media;
    "audio/x-matroska" = media;
    "audio/x-mp3" = media;
    "audio/x-mpegurl" = media;
    "audio/x-ms-wma" = media;
    "audio/x-wav" = media;

    # image formats
    "image/apng" = photos;
    "image/avif" = photos;
    "image/bmp" = photos;
    "image/gif" = photos;
    "image/heic" = photos;
    "image/jp2" = photos;
    "image/jpeg" = photos;
    "image/jxl" = photos;
    "image/png" = photos;
    "image/qoi" = photos;
    "image/svg+xml" = photos;
    "image/tiff" = photos;
    "image/vnd.microsoft.icon" = photos;
    "image/webp" = photos;
    "image/x-icon" = photos;
    "image/x-qoi" = photos;

    # video formats
    "video/3gpp" = media;
    "video/mp2t" = media;
    "video/mp4" = media;
    "video/mpeg" = media;
    "video/ogg" = media;
    "video/quicktime" = media;
    "video/webm" = media;
    "video/x-flv" = media;
    "video/x-m4v" = media;
    "video/x-matroska" = media;
    "video/x-msvideo" = media;
    "video/x-ms-wmv" = media;

    # docs
    "application/pdf" = docs;
    "application/vnd.comicbook+zip" = docs;
    "application/vnd.comicbook-rar" = docs;
    "application/x-cbr" = docs;
    "application/x-cbz" = docs;
    "text/csv" = text;
    "text/markdown" = text;
    "text/plain" = text;
  };
in
{
  xdg.mimeApps = {
    enable = true;
    associations.added = associations;
    defaultApplications = associations;
  };
}
