{
  config,
  lib,
  osConfig,
  ...
}:
{
  programs.halloy = {
    enable = true;

    settings = {
      # servers
      servers.RizonAlt = {
        chathistory = true;
        nickname = "nat";
        password_file = "soju-jattelik.passwd";
        port = 6667;
        server = "jattelik";
        username = "nat/RizonAlt@halloy-${osConfig.networking.hostName}";
        use_tls = false;
      };

      servers.LiberaChat = {
        chathistory = true;
        nickname = "nat";
        password_file = "soju-jattelik.passwd";
        port = 6667;
        server = "jattelik";
        username = "nat/irc.libera.chat@halloy-${osConfig.networking.hostName}";
        use_tls = false;
      };

      servers.Rizon = {
        chathistory = true;
        nickname = "nat";
        password_file = "soju-jattelik.passwd";
        port = 6667;
        server = "jattelik";
        username = "nat/irc.rizon.net@halloy-${osConfig.networking.hostName}";
        use_tls = false;
      };

      servers.OFTC = {
        chathistory = true;
        nickname = "nat";
        password_file = "soju-jattelik.passwd";
        port = 6667;
        server = "jattelik";
        username = "nat/irc.oftc.net@halloy-${osConfig.networking.hostName}";
        use_tls = false;
      };

      font = {
        family = config.stylix.fonts.monospace.name;
        size = lib.mkForce 15;
      };

      # actions
      actions.sidebar = {
        buffer = "replace-pane";
        focused_buffer = "close-pane";
      };

      # buffer
      buffer = {
        # server_messages
        server_messages = {
          join.smart = 180;
          part.smart = 180;
          quit.smart = 180;
          topic.enabled = false;
        };

        # nicknames
        nickname.brackets = {
          left = "";
          right = ":";
        };

        # timestamps
        timestamp = {
          format = "%T";
          brackets = {
            left = "[";
            right = "]";
          };
        };

        channel = {
          # nicklist
          nicklist.alignment = "left";
          # topic
          topic.enabled = true;
        };
      };

      # highlights
      highlights = {
        # i don't want notifications about someone setting up nat
        nickname.exclude = [ "*" ];
        match = [
          {
            words = [
              "@nat"
              "nat:"
              "nat1337"
            ];
            case_insensitive = true;
          }
        ];
      };

      # notifications
      notifications = {
        direct_message = {
          show_toast = true;
          delay = 5;
        };

        highlight = {
          show_toast = true;
          delay = 5;
        };

        file_transfer_request = {
          show_toast = true;
          delay = 5;
        };
      };
    };
  };
}
