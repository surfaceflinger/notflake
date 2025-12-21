{ lib, pkgs, ... }:
{
  environment.shells = [ pkgs.zsh ];
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    histFile = "$HOME/.config/zsh/history";
    histSize = 999999999;
    syntaxHighlighting.enable = true;
    vteIntegration = true;
    setOptions = [
      "autocd"
      "extended_history"
      "globdots"
      "hist_expire_dups_first"
      "hist_ignore_all_dups"
      "hist_ignore_space"
      "hist_reduce_blanks"
      "interactive_comments"
      "prompt_subst"
    ];
    shellAliases = with pkgs; rec {
      cat = "${lib.getExe bat} -Pp";
      ls = "ls --color=auto --group-directories-first --classify=auto";
      scpi = "${lib.getExe' openssh "scp"} -o IdentitiesOnly=yes";
      sshi = "${lib.getExe' openssh "ssh"} -o IdentitiesOnly=yes";
      tree = lib.getExe tre-command;
    };
    shellInit = ''
      mkdir -p "$HOME/.config/zsh" && touch "$HOME/.config/zsh/history"
      zsh-newuser-install () {}
      lk () {cd "$(${lib.getExe pkgs.walk} "$@")"}
    '';
    promptInit = ''
      autoload -U colors && colors # Enable colors
      HOST=$(${lib.getExe' pkgs.inetutils "hostname"}) # Fixup for cloud-init sourced hostname
      stty stop undef # Disable ctrl-s to freeze terminal.
      zstyle ':completion:*' menu select # select-style completions

      LS_COLORS=$(${lib.getExe pkgs.vivid} generate catppuccin-mocha)

      # setup prompt with git and awsume integration
      autoload -Uz vcs_info
      precmd() {
          # setup colors
          local awsume_info
          local awsume_info_color="%F{153}"
          local userhost_color="%F{183}"
          local dir_color="%F{225}"
          local prompt_symbol="✨"
          local vcs_info_color="%F{190}"

          if [[ $UID -eq 0 ]]; then
              userhost_color="%F{161}"
              prompt_symbol="😾"
          fi

          # setup awsume + vcs
          if [[ -n "$AWSUME_PROFILE" ]]; then
              awsume_info="$awsume_info_color☁️  $AWSUME_PROFILE%f "
          fi
          zstyle ":vcs_info:git:*" formats "''${vcs_info_color}🌸 %b%f "
          vcs_info

          # setup prompt
          local BASE="$userhost_color%n@%m %f[$dir_color%~%f] $vcs_info_msg_0_$awsume_info"

          # don't use colors/emojis on dumb terminals
          case $TERM in
          xterm*)
              PS1="$BASE$prompt_symbol ";;
          *)
              PS1=$(echo "$BASE%# " | tr -cd "[:print:]");
          esac
      }

      echo -ne '\e[5 q' # Use beam shape cursor on startup.
      preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
    '';
  };
}
