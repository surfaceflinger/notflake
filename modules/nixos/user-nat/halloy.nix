{ osConfig, ... }:
{
  programs.halloy = {
    enable = true;

    settings = {
      # theme
      theme = {
        dark = "dark";
        light = "light";
      };

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

      # font
      font = {
        family = "Cascadia Mono PL";
        size = 15;
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

    themes = {
      dark = {
        general = {
          background = "#1e1e2e";
          border = "#b4befe";
          horizontal_rule = "#313244";
          unread_indicator = "#f9e2af";
        };
        text = {
          error = "#f38ba8";
          primary = "#cdd6f4";
          secondary = "#585b70";
          success = "#a6e3a1";
          tertiary = "#f9e2af";
        };
        buffer = {
          action = "#a6e3a1";
          background = "#1e1e2e";
          background_text_input = "#181825";
          background_title_bar = "#181825";
          border = "#45475a";
          border_selected = "#b4befe";
          code = "#cba6f7";
          highlight = "#181825";
          nickname = "#94e2d5";
          selection = "#313244";
          timestamp = "#cdd6f4";
          topic = "#585b70";
          url = "#89b4fa";
          server_messages = {
            default = "#94e2d5";
            join = "#a6e3a1";
            part = "#f38ba8";
            quit = "#f38ba8";
          };
        };
        buttons = {
          primary = {
            background = "#1e1e2e";
            background_hover = "#313244";
            background_selected = "#45475a";
            background_selected_hover = "#585b70";
          };
          secondary = {
            background = "#181825";
            background_hover = "#313244";
            background_selected = "#45475a";
            background_selected_hover = "#585b70";
          };
        };
      };

      light = {
        general = {
          background = "#eff1f5";
          border = "#7287fd";
          horizontal_rule = "#ccd0da";
          unread_indicator = "#df8e1d";
        };
        text = {
          error = "#d20f39";
          primary = "#4c4f69";
          secondary = "#acb0be";
          success = "#40a02b";
          tertiary = "#df8e1d";
        };
        buffer = {
          action = "#40a02b";
          background = "#eff1f5";
          background_text_input = "#e6e9ef";
          background_title_bar = "#e6e9ef";
          border = "#bcc0cc";
          border_selected = "#7287fd";
          code = "#8839ef";
          highlight = "#e6e9ef";
          nickname = "#179299";
          selection = "#ccd0da";
          timestamp = "#4c4f69";
          topic = "#acb0be";
          url = "#1e66f5";
          server_messages = {
            default = "#179299";
            join = "#40a02b";
            part = "#d20f39";
            quit = "#d20f39";
          };
        };
        buttons = {
          primary = {
            background = "#eff1f5";
            background_hover = "#ccd0da";
            background_selected = "#bcc0cc";
            background_selected_hover = "#acb0be";
          };
          secondary = {
            background = "#e6e9ef";
            background_hover = "#ccd0da";
            background_selected = "#bcc0cc";
            background_selected_hover = "#acb0be";
          };
        };
      };
    };
  };
}
