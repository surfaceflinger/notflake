{ inputs, ... }:
{
  imports = [ inputs.schizofox.result.homeManagerModule ];

  home.sessionVariables.BROWSER = "schizofox";

  programs.schizofox = {
    enable = true;

    security.sandbox.enable = false;

    settings = {
      # schizofox overrides
      "browser.download.useDownloadDir" = true;
      "browser.uidensity" = 0;
      "dom.event.clipboardevents.enabled" = true;
      "privacy.resistFingerprinting" = false;
      "privacy.resistFingerprinting.letterboxing" = false;

      # mine
      "browser.search.context.loadInBackground" = true;
      "browser.tabs.firefox-view" = false;
      "browser.tabs.loadBookmarksInBackground" = true;
      "browser.tabs.loadDivertedInBackground" = false;
      "browser.tabs.loadInBackground" = true;
      "media.webrtc.camera.allow-pipewire" = true;
      "places.history.enabled" = false;
      "toolkit.tabbox.switchByScrolling" = true;

      # mine - gnome theme
      "gnomeTheme.activeTabContrast" = true;
      "gnomeTheme.hideWebrtcIndicator" = true;
      "gnomeTheme.normalWidthTabs" = true;
      "svg.context-properties.content.enabled" = true;

      # mine - gpu
      "layers.acceleration.force-enabled" = true;
      "media.ffmpeg.vaapi.enabled" = true;
    };

    extensions = {
      enableDefaultExtensions = false;
      enableExtraExtensions = true;
      extraExtensions = {
        "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/augmented-steam/latest.xpi";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        "{74145f27-f039-47ce-a470-a662b129930a}".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
        "7esoorv3@alefvanoon.anonaddy.me".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
        "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/refined-github-/latest.xpi";
        "adnauseam@rednoise.org".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/adnauseam/latest.xpi";
        "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/violentmonkey/latest.xpi";
        "{b5501fd1-7084-45c5-9aa6-567c2fcf5dc6}".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/ruffle_rs/latest.xpi";
        "{b86e4813-687a-43e6-ab65-0bde4ab75758}".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/localcdn-fork-of-decentraleyes/latest.xpi";
        "{cb31ec5d-c49a-4e5a-b240-16c767444f62}".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/indie-wiki-buddy/latest.xpi";
        "cliget@zaidabdulla.com".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/cliget/latest.xpi";
        "deArrow@ajay.app".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/dearrow/latest.xpi";
        "privacypass@kagi.com".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/kagi-privacy-pass/latest.xpi";
        "search@kagi.com".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/kagi-search-for-firefox/latest.xpi";
        "sponsorBlocker@ajay.app".install_url =
          "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
      };
      darkreader.enable = false;
      simplefox.enable = false;
    };

    misc = {
      contextMenu.enable = true;
      disableWebgl = false;
      displayBookmarksInToolbar = "always";
      drm.enable = true;
      firefoxSync = true;
    };

    search = {
      defaultSearchEngine = "Kagi";
      addEngines = [
        {
          Name = "Kagi";
          Description = "Search";
          Alias = "!kagi";
          Method = "GET";
          URLTemplate = "https://kagi.com/search?q={searchTerms}";
        }
        {
          Name = "Googol";
          Description = "Not worth using anymore tbh";
          Alias = "!goog";
          Method = "GET";
          URLTemplate = "https://google.com/search?q={searchTerms}";
        }
        {
          Name = "Parcels";
          Description = "drugs tracking";
          Alias = "!track";
          Method = "GET";
          URLTemplate = "https://parcelsapp.com/en/tracking/{searchTerms}";
        }
        {
          Name = "Anna's Archive";
          Description = "The largest truly open library in human history.";
          Alias = "!anna";
          Method = "GET";
          URLTemplate = "https://annas-archive.org/search?q={searchTerms}";
        }
        {
          Name = "TorrentGalaxy";
          Description = "torrents yeah";
          Alias = "!galaxy";
          Method = "GET";
          URLTemplate = "https://torrentgalaxy.to/torrents.php?search={searchTerms}";
        }
      ];
    };

    theme = {
      defaultUserChrome.enable = false;
      defaultUserContent.enable = false;
      extraUserContent = ''
        @import "${inputs.firefox-gnome-theme.result}/userContent.css";
      '';
      extraUserChrome = ''
        @import "${inputs.firefox-gnome-theme.result}/userChrome.css";
      '';
    };
  };
}
