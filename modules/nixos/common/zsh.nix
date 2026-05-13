{ lib, pkgs, ... }:
let
  lsColors = pkgs.runCommand "ls-colors-ansi" { } ''
    ${lib.getExe pkgs.vivid} generate ansi > $out
  '';
in
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
      "share_history"
    ];
    shellAliases = with pkgs; rec {
      cat = "${lib.getExe bat} -Pp";
      ls = "ls --color=auto --group-directories-first --classify=auto";
      scpi = "${lib.getExe' openssh "scp"} -o IdentitiesOnly=yes";
      sshi = "${lib.getExe' openssh "ssh"} -o IdentitiesOnly=yes";
      tree = lib.getExe tre-command;
    };
    shellInit = ''
      [[ -e "$HOME/.config/zsh/history" ]] || {
          mkdir -p "$HOME/.config/zsh" && touch "$HOME/.config/zsh/history"
      }
      zsh-newuser-install () {}
      lk () {cd "$(${lib.getExe pkgs.walk} "$@")"}
      export LS_COLORS=$(<${lsColors})
    '';
    promptInit = ''
      stty stop undef # Disable ctrl-s to freeze terminal.
      zstyle ':completion:*' menu select # select-style completions

      autoload -Uz vcs_info
      zstyle ':vcs_info:git:*' check-for-changes true
      zstyle ':vcs_info:git:*' stagedstr '%F{yellow}+%f'
      zstyle ':vcs_info:git:*' unstagedstr '%F{red}*%f'
      zstyle ':vcs_info:git:*' formats '%F{green}🌸 %b%c%u%F{green}%f '

      # only the awsume segment + vcs_info change per-prompt
      precmd() {
          if [[ -n "$AWSUME_PROFILE" ]]; then
              awsume_info="%F{blue}☁️  $AWSUME_PROFILE%f "
          else
              awsume_info=""
          fi
          vcs_info
      }

      () {
          local userhost_color prompt_symbol
          if [[ $UID -eq 0 ]]; then
              userhost_color='%F{red}'; prompt_symbol='😾'
          else
              userhost_color='%F{magenta}'; prompt_symbol='✨'
          fi

          case $TERM in
          xterm*)
              PS1="''${userhost_color}%n@%m %f[%F{cyan}%~%f] \''${vcs_info_msg_0_}\''${awsume_info}%(?..%F{red}✗ %?%f )''${prompt_symbol} " ;;
          *)
              PS1=$(print -n "''${userhost_color}%n@%m %f[%F{cyan}%~%f] %(?..[%?] )%# " | tr -cd '[:print:]') ;;
          esac
      }

      print -n '\e[5 q' # Use beam shape cursor on startup.
      preexec() { print -n '\e[5 q' ;} # Use beam shape cursor for each new prompt.
    '';
  };
}
